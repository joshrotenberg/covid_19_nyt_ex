defmodule Covid19Web.CountyControllerTest do
  use Covid19Web.ConnCase

  alias Covid19.Data
  alias Covid19.Data.County

  @create_attrs %{
    cases: 42,
    county: "some county",
    date: ~D[2010-04-17],
    deaths: 42,
    fips: 42,
    state: "some state"
  }
  @update_attrs %{
    cases: 43,
    county: "some updated county",
    date: ~D[2011-05-18],
    deaths: 43,
    fips: 43,
    state: "some updated state"
  }
  @invalid_attrs %{cases: nil, county: nil, date: nil, deaths: nil, fips: nil, state: nil}

  def fixture(:county) do
    {:ok, county} = Data.create_county(@create_attrs)
    county
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all counties", %{conn: conn} do
      conn = get(conn, Routes.county_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create county" do
    test "renders county when data is valid", %{conn: conn} do
      conn = post(conn, Routes.county_path(conn, :create), county: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.county_path(conn, :show, id))

      assert %{
               "id" => id,
               "cases" => 42,
               "county" => "some county",
               "date" => "2010-04-17",
               "deaths" => 42,
               "fips" => 42,
               "state" => "some state"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.county_path(conn, :create), county: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update county" do
    setup [:create_county]

    test "renders county when data is valid", %{conn: conn, county: %County{id: id} = county} do
      conn = put(conn, Routes.county_path(conn, :update, county), county: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.county_path(conn, :show, id))

      assert %{
               "id" => id,
               "cases" => 43,
               "county" => "some updated county",
               "date" => "2011-05-18",
               "deaths" => 43,
               "fips" => 43,
               "state" => "some updated state"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, county: county} do
      conn = put(conn, Routes.county_path(conn, :update, county), county: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete county" do
    setup [:create_county]

    test "deletes chosen county", %{conn: conn, county: county} do
      conn = delete(conn, Routes.county_path(conn, :delete, county))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.county_path(conn, :show, county))
      end
    end
  end

  defp create_county(_) do
    county = fixture(:county)
    {:ok, county: county}
  end
end
