defmodule Covid19.Repo.Migrations.AddCountiesIndex do
  use Ecto.Migration

  def change do
    create index(:counties, [:county, :state, :fips])
  end
end
