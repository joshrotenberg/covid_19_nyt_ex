defmodule Covid19.Data.US do
  use Ecto.Schema
  import Ecto.Changeset

  schema "us" do
    field :date, :date
    field :cases, :integer
    field :deaths, :integer

    timestamps()
  end

  @doc false
  def changeset(us, attrs) do
    us
    |> cast(attrs, [:date, :cases, :deaths])
    |> validate_required([:date, :cases, :deaths])
    |> unique_constraint(:date, name: :us_date_index)
  end
end
