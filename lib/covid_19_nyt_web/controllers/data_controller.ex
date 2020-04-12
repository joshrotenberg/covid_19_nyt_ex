defmodule Covid19Web.DataController do
  use Covid19Web, :controller

  alias Covid19.Data

  require Logger

  action_fallback Covid19Web.FallbackController

  def all_states(conn, _params) do
    states = Data.list_states()
    render(conn, "state_index.json", states: states)
  end

  def all_counties(conn, _params) do
    counties = Data.list_counties()
    render(conn, "county_index.json", counties: counties)
  end

  def state(conn, %{"state_name" => state_name}) do
    states = Data.get_state!(URI.decode(state_name))
    render(conn, "state_index.json", states: states)
  end

  def state_county(conn, %{"state_name" => state_name, "county_name" => county_name}) do
    counties = Data.get_county!(URI.decode(state_name), URI.decode(county_name))
    render(conn, "county_index.json", counties: counties)
  end

  def fips(conn, %{"fips" => fips}) do
    case String.length(fips) do
      2 ->
        states = Data.get_state_by_fips!(fips)
        render(conn, "state_index.json", states: states)

      5 ->
        counties = Data.get_county_by_fips!(fips)
        render(conn, "county_index.json", counties: counties)

      _ ->
        send_resp(conn, :not_found, "")
    end
  end

  def missing_fips(conn, _params) do
    missing = Data.missing_fips()
    render(conn, "county_index.json", counties: missing)
  end
end
