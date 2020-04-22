defmodule Covid19.Data.County do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "counties" do
    field :cases, :integer
    field :county, :string
    field :date, :date
    field :deaths, :integer
    field :fips, :string
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(county, attrs) do
    county
    |> cast(attrs, [:date, :county, :state, :fips, :cases, :deaths])
    |> validate_required([:date, :county, :state, :cases, :deaths])
    |> unique_constraint(:date, name: :counties_date_county_state_index)
  end
end
