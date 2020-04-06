defmodule Covid19.Data.State do
  use Ecto.Schema
  import Ecto.Changeset

  schema "states" do
    field :cases, :integer
    field :date, :date
    field :deaths, :integer
    field :fips, :integer
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:date, :state, :fips, :cases, :deaths])
    |> validate_required([:date, :state, :fips, :cases, :deaths])
  end
end
