defmodule Covid19.Update.County do
  @moduledoc """
  County CSV file update pipeline.
  """

  alias Covid19.Update.{HTTP, CSV}
  alias Covid19.Data
  require Logger

  @counties_url "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv"

  def update_counties do
    Logger.debug("updating county data")

    HTTP.get(@counties_url)
    |> HTTP.lines()
    |> Enum.take(10)
    |> CSV.decode()
    |> Stream.map(&format_county/1)
    |> Stream.map(&Data.upsert_county/1)
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
