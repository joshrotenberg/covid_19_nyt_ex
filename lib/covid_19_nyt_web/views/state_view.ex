defmodule Covid19Web.StateView do
  use Covid19Web, :view
  alias Covid19Web.StateView

  def render("index.json", %{states: states}) do
    %{data: render_many(states, StateView, "state.json")}
  end

  def render("show.json", %{state: state}) do
    %{data: render_one(state, StateView, "state.json")}
  end

  def render("state.json", %{state: state}) do
    %{id: state.id,
      date: state.date,
      state: state.state,
      fips: state.fips,
      cases: state.cases,
      deaths: state.deaths}
  end
end
