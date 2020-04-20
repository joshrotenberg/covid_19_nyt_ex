defmodule Covid19Web.Api.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(Covid19.Api.Schema.StateTypes)
  import_types(Covid19.Api.Schema.CountyTypes)

  query do
    import_fields(:state_queries)
    import_fields(:county_queries)
  end
end
