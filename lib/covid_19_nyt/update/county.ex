defmodule Covid19.Update.County do
  alias Covid19.Data.County
  alias Covid19.Update.{HTTP, CSV}
  alias Covid19.Repo
  require Logger

  @counties_url "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"

  def update_counties do
    Logger.debug("updating county data")

    HTTP.get(@counties_url)
    |> HTTP.lines()
    |> CSV.decode()
    |> Enum.take(5)
    |> Stream.map(&format_county/1)
    |> Stream.map(fn m ->
      changeset = County.changeset(%County{}, m)

      case changeset.valid? do
        true ->
          Repo.insert(changeset,
            on_conflict: [
              set: [cases: changeset.changes.cases, deaths: changeset.changes.deaths]
            ],
            conflict_target: [:date, :county, :state]
          )

        false ->
          Logger.error(changeset.errors)
      end
    end)
    |> Stream.run()

    {:ok, :counties_update}
  end

  def format_county(
        {:ok,
         %{
           "cases" => cases,
           "date" => date,
           "state" => state,
           "county" => county,
           "fips" => fips,
           "deaths" => deaths
         }}
      ) do
    try do
      %{
        cases: String.to_integer(cases),
        deaths: String.to_integer(deaths),
        fips: fips,
        date: Date.from_iso8601!(date),
        state: state,
        county: county
      }
    rescue
      e in ArgumentError ->
        Logger.error(e.message)
        %{}

      e in _ ->
        Logger.error(e)
    end
  end
end
