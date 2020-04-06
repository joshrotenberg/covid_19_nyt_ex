defmodule Covid19Web.CountyView do
  use Covid19Web, :view
  alias Covid19Web.CountyView

  def render("index.json", %{counties: counties}) do
    %{data: render_many(counties, CountyView, "county.json")}
  end

  def render("show.json", %{county: county}) do
    %{data: render_one(county, CountyView, "county.json")}
  end

  def render("county.json", %{county: county}) do
    %{id: county.id,
      date: county.date,
      county: county.county,
      state: county.state,
      fips: county.fips,
      cases: county.cases,
      deaths: county.deaths}
  end
end
