defmodule Covid19.Api.Schema.StateTypes do
  use Absinthe.Schema.Notation

  alias Covid19Web.Api.Resolvers
  @desc "US State Covid19 Data"
  object :state do
    field :id, non_null(:id)
    field :state, non_null(:string)
    field :fips, :string
    field :cases, non_null(:integer)
    field :deaths, non_null(:integer)
    field :date, non_null(:date)
  end

  object :state_queries do
    @desc "Get all state data"
    field :states, list_of(:state) do
      resolve(&Resolvers.StateResolver.list/3)
    end

    @desc "Get state data for a particular state"
    field :state, list_of(:state) do
      # arg(:state, non_null(:string))
      arg(:state, :string)
      arg(:fips, :string)
      arg(:cases, :integer)
      arg(:deaths, :integer)
      arg(:date, :date)
      resolve(&Resolvers.StateResolver.find/3)
    end
  end
end
