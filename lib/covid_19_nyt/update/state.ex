defmodule Covid19.Update.State do
  alias Covid19.Data.State
  alias Covid19.Update.{HTTP, CSV}
  alias Covid19.Repo
  require Logger

  @states_url "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"
  def update_states do
    Logger.debug("updating state data")

    HTTP.get(@states_url)
    |> HTTP.lines()
    |> CSV.decode()
    |> Enum.take(5)
    |> Stream.map(&format_state/1)
    |> Stream.map(fn m ->
      changeset = State.changeset(%State{}, m)

      case changeset.valid? do
        true ->
          Repo.insert(changeset,
            on_conflict: [
              set: [cases: changeset.changes.cases, deaths: changeset.changes.deaths]
            ],
            conflict_target: [:date, :state]
          )

        false ->
          Logger.error(changeset.errors)
      end
    end)
    |> Stream.run()

    {:ok, :states_update}
  end

  def format_state(
        {:ok,
         %{
           "cases" => cases,
           "date" => date,
           "state" => state,
           "fips" => fips,
           "deaths" => deaths
         }}
      ) do
    %{
      cases: String.to_integer(cases),
      deaths: String.to_integer(deaths),
      fips: fips,
      date: Date.from_iso8601!(date),
      state: state
    }
  end
end
