defmodule Covid19Web.StateControllerTest do
  use Covid19Web.ConnCase

  alias Covid19.Data
  alias Covid19.Data.State

  @state_attrs %{
    cases: 42,
    date: ~D[2010-04-17],
    deaths: 42,
    fips: "42",
    state: "some state"
  }

  @county_attrs %{
    cases: 43,
    date: ~D[2010-04-17],
    deaths: 43,
    fips: "42424",
    state: "some state",
    county: "some county"
  }

  def fixture(:state) do
    {:ok, state} = Data.create_state(@state_attrs)
    state
  end

  def fixture(:county) do
    {:ok, county} = Data.create_county(@county_attrs)
    county
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "states" do
    setup [:create_state]

    test "lists all states", %{conn: conn} do
      conn = get(conn, Routes.api_data_path(conn, :all_states))

      assert [
               %{
                 "id" => id,
                 "cases" => 42,
                 "date" => "2010-04-17",
                 "deaths" => 42,
                 "fips" => "42",
                 "state" => "some state"
               }
             ] = json_response(conn, 200)["data"]
    end

    test "lookup state by name", %{conn: conn} do
      conn = get(conn, Routes.api_data_path(conn, :state, "some state"))

      assert [
               %{
                 "id" => id,
                 "cases" => 42,
                 "date" => "2010-04-17",
                 "deaths" => 42,
                 "fips" => "42",
                 "state" => "some state"
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  describe "counties" do
    setup [:create_county]

    test "lists all counties", %{conn: conn} do
      conn = get(conn, Routes.api_data_path(conn, :all_counties))

      assert [
               %{
                 "id" => id,
                 "cases" => 43,
                 "date" => "2010-04-17",
                 "deaths" => 43,
                 "fips" => "42424",
                 "state" => "some state",
                 "county" => "some county"
               }
             ] = json_response(conn, 200)["data"]
    end

    test "lookup state and county by name", %{conn: conn} do
      conn = get(conn, Routes.api_data_path(conn, :state_county, "some state", "some county"))

      assert [
               %{
                 "id" => id,
                 "cases" => 43,
                 "date" => "2010-04-17",
                 "deaths" => 43,
                 "fips" => "42424",
                 "state" => "some state",
                 "county" => "some county"
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  describe "fips" do
    setup [:create_county]

    test "lookup by fips", %{conn: conn} do
      conn = get(conn, Routes.api_data_path(conn, :fips, "42424"))

      assert [
               %{
                 "id" => id,
                 "cases" => 43,
                 "date" => "2010-04-17",
                 "deaths" => 43,
                 "fips" => "42424",
                 "state" => "some state",
                 "county" => "some county"
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  defp create_state(_) do
    state = fixture(:state)
    {:ok, state: state}
  end

  defp create_county(_) do
    county = fixture(:county)
    {:ok, county: county}
  end
end
