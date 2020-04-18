defmodule Covid19.Repo.Migrations.AddUsIndex do
  use Ecto.Migration

  def change do
    create unique_index(:us, [:date], name: :us_date_index)
  end
end
