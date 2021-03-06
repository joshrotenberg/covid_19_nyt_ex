defmodule Covid19.Data.State do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "states" do
    field :cases, :integer
    field :date, :date
    field :deaths, :integer
    field :fips, :string
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:date, :state, :fips, :cases, :deaths])
    |> validate_required([:date, :state, :cases, :deaths])
    |> unique_constraint(:date, name: :states_date_state_index)
  end
end
