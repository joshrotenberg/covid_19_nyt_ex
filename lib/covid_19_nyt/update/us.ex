defmodule Covid19.Update.US do
  @moduledoc """
  US CSV file update pipeline.
  """
  alias Covid19.Data
  alias Covid19.Update.{CSV, HTTP}

  require Logger

  @us_url "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us.csv"

  def update_us do
    Logger.debug("updating us")

    HTTP.get(@us_url)
    |> HTTP.lines()
    |> CSV.decode()
    |> Stream.map(&format_us/1)
    |> Stream.map(&Data.upsert_us/1)
    |> Stream.run()

    {:ok, :us_update}
  end

  def format_us({:ok, %{"cases" => cases, "date" => date, "deaths" => deaths}}) do
    %{
      cases: String.to_integer(cases),
      deaths: String.to_integer(deaths),
      date: Date.from_iso8601!(date)
    }
  end
end
