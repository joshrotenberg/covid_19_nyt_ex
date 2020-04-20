defmodule Covid19Web.Api.Resolvers.Dynamic do
  import Ecto.Query

  def filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {:state, value}, dynamic ->
        dynamic([p], ^dynamic and ilike(p.state, ^value))

      {:county, value}, dynamic ->
        dynamic([p], ^dynamic and ilike(p.county, ^value))

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

  def filter_where_match(params) do
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
