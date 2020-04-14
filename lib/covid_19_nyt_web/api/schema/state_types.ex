defmodule Covid19.Api.Schema.StateTypes do
  use Absinthe.Schema.Notation

  alias Covid19Web.Api.Resolvers
  @desc "A US State"
  object :state do
    field :id, non_null(:id)
    field :state, non_null(:string)
    field :fips, :string
    field :cases, non_null(:integer)
    field :deaths, non_null(:integer)
    field :date, non_null(:date)
  end

  object :state_queries do
    @desc "Get all states"
    field :states, list_of(:state) do
      resolve(&Resolvers.StateResolver.list/3)
    end

    @desc "Get state by name"
    field :state, list_of(:state) do
      arg(:state, non_null(:string))
      resolve(&Resolvers.StateResolver.find/3)
    end
  end
end
