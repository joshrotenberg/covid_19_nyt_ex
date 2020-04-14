defmodule Covid19Web.Api.Resolvers.StateResolver do
  alias Covid19.Data
  alias Covid19.Data.State
  import Ecto.Query
  alias Covid19.Repo

  def list(_parent, _args, _resolution) do
    {:ok, Repo.all(State)}
  end

  def get(_parent, args, _resolution) do
    # case Repo.all(from s in State, where: s.state == ^args[:state]) do
    case Repo.get(State, args[:id]) do
      nil -> {:error, "Not found"}
      states -> {:ok, states}
    end
  end

  def find(_parent, args, _resolution) do
    IO.inspect(args)

    case Repo.all(
           from s in State,
             where: s.state == ^args[:state],
             order_by: s.date
         ) do
      nil -> {:error, "Not found"}
      states -> {:ok, states}
    end
  end
end
