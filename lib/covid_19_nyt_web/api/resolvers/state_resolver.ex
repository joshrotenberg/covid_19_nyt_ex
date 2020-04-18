defmodule Covid19Web.Api.Resolvers.StateResolver do
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
    query =
      State |> where(^filter_where(args)) |> where(^filter_where_match(args)) |> order_by(:date)

    case Repo.all(query) do
      nil -> {:error, "Not found"}
      states -> {:ok, states}
    end
  end

  defp filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {:state, value}, dynamic ->
        dynamic([p], ^dynamic and ilike(p.state, ^value))

      {:date, value}, dynamic ->
        dynamic([p], ^dynamic and p.date == ^value)

      {:fips, value}, dynamic ->
        dynamic([p], ^dynamic and p.fips == ^value)

      {:cases, value}, dynamic ->
        dynamic([p], ^dynamic and p.cases == ^value)

      {:deaths, value}, dynamic ->
        dynamic([p], ^dynamic and p.deaths == ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end

  defp filter_where_match(params) do
    Enum.reduce(params, dynamic(true), fn
      {:date_before, value}, dynamic ->
        dynamic([p], ^dynamic and p.date < ^value)

      {:date_after, value}, dynamic ->
        dynamic([p], ^dynamic and p.date > ^value)

      {:cases_less_than, value}, dynamic ->
        dynamic([p], ^dynamic and p.cases < ^value)

      {:cases_greater_than, value}, dynamic ->
        dynamic([p], ^dynamic and p.cases > ^value)

      {:deaths_less_than, value}, dynamic ->
        dynamic([p], ^dynamic and p.deaths < ^value)

      {:deaths_greater_than, value}, dynamic ->
        dynamic([p], ^dynamic and p.deaths > ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
