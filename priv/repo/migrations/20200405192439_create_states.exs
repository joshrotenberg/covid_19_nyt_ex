defmodule Covid19.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :date, :date
      add :state, :string
      add :fips, :string
      add :cases, :integer
      add :deaths, :integer

      timestamps()
    end
  end
end
