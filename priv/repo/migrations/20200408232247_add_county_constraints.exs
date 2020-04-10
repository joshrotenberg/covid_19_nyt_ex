defmodule Covid19.Repo.Migrations.AddCountyConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:counties, [:date, :county, :state],
             name: :counties_date_county_state_index
           )
  end
end
