defmodule Covid19Web.StateControllerTest do
  use Covid19Web.ConnCase

  alias Covid19.Data
  alias Covid19.Data.State

  @create_attrs %{
    cases: 42,
    date: ~D[2010-04-17],
    deaths: 42,
    fips: 42,
    state: "some state"
  }
  @update_attrs %{
    cases: 43,
    date: ~D[2011-05-18],
    deaths: 43,
    fips: 43,
    state: "some updated state"
  }
  @invalid_attrs %{cases: nil, date: nil, deaths: nil, fips: nil, state: nil}

  def fixture(:state) do
    {:ok, state} = Data.create_state(@create_attrs)
    state
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all states", %{conn: conn} do
      conn = get(conn, Routes.state_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create state" do
    @tag :skip
    test "renders state when data is valid", %{conn: conn} do
      conn = post(conn, Routes.state_path(conn, :create), state: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.state_path(conn, :show, id))

      assert %{
               "id" => id,
               "cases" => 42,
               "date" => "2010-04-17",
               "deaths" => 42,
               "fips" => 42,
               "state" => "some state"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.state_path(conn, :create), state: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update state" do
    setup [:create_state]

    @tag :skip
    test "renders state when data is valid", %{conn: conn, state: %State{id: id} = state} do
      conn = put(conn, Routes.state_path(conn, :update, state), state: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.state_path(conn, :show, id))

      assert %{
               "id" => id,
               "cases" => 43,
               "date" => "2011-05-18",
               "deaths" => 43,
               "fips" => 43,
               "state" => "some updated state"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, state: state} do
      conn = put(conn, Routes.state_path(conn, :update, state), state: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete state" do
    setup [:create_state]

    @tag :skip
    test "deletes chosen state", %{conn: conn, state: state} do
      conn = delete(conn, Routes.state_path(conn, :delete, state))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.state_path(conn, :show, state))
      end
    end
  end

  defp create_state(_) do
    state = fixture(:state)
    {:ok, state: state}
  end
end
