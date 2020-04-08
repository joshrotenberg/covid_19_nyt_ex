defmodule Covid19Web.DataView do
  use Covid19Web, :view
  alias Covid19Web.DataView

  def render("county_index.json", %{counties: counties}) do
    %{data: render_many(counties, DataView, "county.json", as: :county)}
  end

  def render("state_index.json", %{states: states}) do
    %{data: render_many(states, DataView, "state.json", as: :state)}
  end

  def render("show_county.json", %{county: county}) do
    %{data: render_one(county, DataView, "county.json")}
  end

  def render("show_state.json", %{state: state}) do
    %{data: render_one(state, DataView, "state.json")}
  end

  def render("county.json", %{county: county}) do
    %{
      id: county.id,
      date: county.date,
      county: county.county,
      state: county.state,
      fips: county.fips,
      cases: county.cases,
      deaths: county.deaths
    }
  end

  def render("state.json", %{state: state}) do
    %{
      id: state.id,
      date: state.date,
      state: state.state,
      fips: state.fips,
      cases: state.cases,
      deaths: state.deaths
    }
  end
end
