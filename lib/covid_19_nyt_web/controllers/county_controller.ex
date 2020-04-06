defmodule Covid19Web.CountyController do
  use Covid19Web, :controller

  alias Covid19.Data
  alias Covid19.Data.County

  action_fallback Covid19Web.FallbackController

  def index(conn, _params) do
    counties = Data.list_counties()
    render(conn, "index.json", counties: counties)
  end

  def create(conn, %{"county" => county_params}) do
    with {:ok, %County{} = county} <- Data.create_county(county_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.county_path(conn, :show, county))
      |> render("show.json", county: county)
    end
  end

  def show(conn, %{"id" => id}) do
    county = Data.get_county!(id)
    render(conn, "show.json", county: county)
  end

  def update(conn, %{"id" => id, "county" => county_params}) do
    county = Data.get_county!(id)

    with {:ok, %County{} = county} <- Data.update_county(county, county_params) do
      render(conn, "show.json", county: county)
    end
  end

  def delete(conn, %{"id" => id}) do
    county = Data.get_county!(id)

    with {:ok, %County{}} <- Data.delete_county(county) do
      send_resp(conn, :no_content, "")
    end
  end
end
