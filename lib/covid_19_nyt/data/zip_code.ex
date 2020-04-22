defmodule Covid19.Data.ZipCode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "zip_codes" do
    field :fips, :string
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(data, attrs) do
    data
    |> cast(attrs, [:zip, :fips])
    |> validate_required([:zip, :fips])
    |> unique_constraint(:zip, name: :zip_codes_zip_fips_index)
  end
end
