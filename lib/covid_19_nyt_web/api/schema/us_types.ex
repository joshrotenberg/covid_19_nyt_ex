defmodule Covid19.Api.Schema.USTypes do
  @moduledoc """
  Types for US GraphQL queries.
  """
  use Absinthe.Schema.Notation

  alias Covid19Web.Api.Resolvers

  @desc "US Covid19 Data"
  object :us do
    field :id, non_null(:id)
    field :cases, non_null(:integer)
    field :deaths, non_null(:integer)
    field :date, non_null(:date)
  end

  object :us_queries do
    # @desc "Get all US data"
    # field :us, list_of(:us) do
    # resolve(&Resolvers.USResolver.list/3)
    # end

    @desc "Get us data"
    field :us, list_of(:us) do
      arg(:cases, :integer)
      arg(:deaths, :integer)
      arg(:date, :date)

      arg(:date_before, :date)
      arg(:date_after, :date)

      arg(:cases_less_than, :integer)
      arg(:cases_greater_than, :integer)

      arg(:deaths_less_than, :integer)
      arg(:deaths_greater_than, :integer)

      resolve(&Resolvers.USResolver.find/3)
    end
  end
end
