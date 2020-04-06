defmodule Covid19.Repo.Migrations.CreateCounties do
  use Ecto.Migration

  def change do
    create table(:counties) do
      add :date, :date
      add :county, :string
      add :state, :string
      add :fips, :integer
      add :cases, :integer
      add :deaths, :integer

      timestamps()
    end

  end
end
