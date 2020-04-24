defmodule Covid19.Update.State do
  @moduledoc """
  State CSV file update pipeline.
  """

  alias Covid19.Data
  alias Covid19.Update.{CSV, HTTP}

  require Logger

  @states_url "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv"
  def update_states do
    Logger.debug("updating state data")

    HTTP.get(@states_url)
    |> HTTP.lines()
    |> CSV.decode()
    |> Stream.map(&format_state/1)
    |> Stream.map(&Data.upsert_state/1)
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
