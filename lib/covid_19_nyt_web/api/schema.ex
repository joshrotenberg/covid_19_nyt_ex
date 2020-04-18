defmodule Covid19Web.Api.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(Covid19.Api.Schema.StateTypes)

  query do
    import_fields(:state_queries)
  end
end
