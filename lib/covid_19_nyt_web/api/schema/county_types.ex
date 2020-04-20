defmodule Covid19.Api.Schema.CountyTypes do
  use Absinthe.Schema.Notation

  alias Covid19Web.Api.Resolvers

  @desc "US County Covid19 Data"
  object :county do
    field :id, non_null(:id)
    field :state, non_null(:string)
    field :county, non_null(:string)
    field :fips, :string
    field :cases, non_null(:integer)
    field :deaths, non_null(:integer)
    field :date, non_null(:date)
  end

  object :county_queries do
    @desc "Get all county data"
    field :counties, list_of(:county) do
      resolve(&Resolvers.CountyResolver.list/3)
    end

    @desc "Get county data for a particular county"
    field :county, list_of(:county) do
      arg(:county, :string)
      arg(:state, :string)

      resolve(&Resolvers.CountyResolver.find/3)
    end
  end
end
