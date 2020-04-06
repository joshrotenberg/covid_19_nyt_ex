defmodule Covid19Web.StateController do
  use Covid19Web, :controller

  alias Covid19.Data
  alias Covid19.Data.State

  require Logger

  action_fallback Covid19Web.FallbackController

  def index(conn, _params) do
    states = Data.list_states()
    render(conn, "index.json", states: states)
  end

  def create(conn, %{"state" => state_params}) do
    with {:ok, %State{} = state} <- Data.create_state(state_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.state_path(conn, :show, state))
      |> render("show.json", state: state)
    end
  end

  def show(conn, %{"id" => id}) do
    Logger.debug(inspect(conn.params))
    state = Data.get_state!(id)
    render(conn, "show.json", state: state)
  end

  def update(conn, %{"id" => id, "state" => state_params}) do
    state = Data.get_state!(id)

    with {:ok, %State{} = state} <- Data.update_state(state, state_params) do
      render(conn, "show.json", state: state)
    end
  end

  def delete(conn, %{"id" => id}) do
    state = Data.get_state!(id)

    with {:ok, %State{}} <- Data.delete_state(state) do
      send_resp(conn, :no_content, "")
    end
  end
end
