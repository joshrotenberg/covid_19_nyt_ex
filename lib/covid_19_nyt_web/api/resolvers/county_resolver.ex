defmodule Covid19Web.Api.Resolvers.CountyResolver do
  alias Covid19.Data.County
  import Ecto.Query
  alias Covid19.Repo
  alias Covid19Web.Api.Resolvers.Dynamic

  def list(_parent, _args, _resolution) do
    IO.inspect("called")
    {:ok, Repo.all(County)}
  end

  def find(_parent, args, _resolution) do
    query =
      County
      |> where(^Dynamic.filter_where(args))
      |> where(^Dynamic.filter_where_match(args))
      |> order_by(:date)

    case Repo.all(query) do
      nil -> {:error, "Not found"}
      counties -> {:ok, counties}
    end
  end
end
