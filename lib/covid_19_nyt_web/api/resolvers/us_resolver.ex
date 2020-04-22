defmodule Covid19Web.Api.Resolvers.USResolver do
  alias Covid19.Data.US
  import Ecto.Query
  alias Covid19.Repo

  alias Covid19Web.Api.Resolvers.Dynamic

  def list(_parent, _args, _resolution) do
    {:ok, Repo.all(US)}
  end

  def find(_parent, args, _resolution) do
    query =
      US
      |> where(^Dynamic.filter_where(args))
      |> where(^Dynamic.filter_where_match(args))
      |> order_by(:date)

    case Repo.all(query) do
      nil -> {:error, "Not found"}
      us -> {:ok, us}
    end
  end
end
