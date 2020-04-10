defmodule Covid19.Data.County do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counties" do
    field :cases, :integer
    field :county, :string
    field :date, :date
    field :deaths, :integer
    field :fips, :integer
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(county, attrs) do
    county
    |> cast(attrs, [:date, :county, :state, :fips, :cases, :deaths])
    |> validate_required([:date, :county, :state, :fips, :cases, :deaths])
    |> unique_constraint(:date, name: :counties_date_county_state_index)
  end
end
