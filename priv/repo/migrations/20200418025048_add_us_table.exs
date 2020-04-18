defmodule Covid19.Repo.Migrations.AddUsTable do
  use Ecto.Migration

  def change do
    create table(:us) do
      add :date, :date
      add :cases, :integer
      add :deaths, :integer

      timestamps()
    end
  end
end
