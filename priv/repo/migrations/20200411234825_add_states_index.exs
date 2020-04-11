defmodule Covid19.Repo.Migrations.AddStatesIndex do
  use Ecto.Migration

  def change do
    create index(:states, [:state, :fips])
  end
end
