defmodule Covid19Web.Api.Resolvers.StateResolver do
  @moduledoc """
  State Data resolvers.
  """
  alias Covid19.Data.State
  import Ecto.Query
  alias Covid19.Repo
  alias Covid19Web.Api.Resolvers.Dynamic

  def list(_parent, _args, _resolution) do
    {:ok, Repo.all(State)}
  end

  def get(_parent, args, _resolution) do
    case Repo.get(State, args[:id]) do
      nil -> {:error, "Not found"}
      states -> {:ok, states}
    end
  end

  def find(_parent, args, _resolution) do
    query =
      State
      |> where(^Dynamic.filter_where(args))
      |> where(^Dynamic.filter_where_match(args))
      |> order_by(:date)

    case Repo.all(query) do
      nil -> {:error, "Not found"}
      states -> {:ok, states}
    end
  end
end
