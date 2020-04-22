defmodule Covid19.Repo.Migrations.CreateZipCodes do
  use Ecto.Migration

  def change do
    create table(:zip_codes) do
      add :zip, :string
      add :fips, :string

      timestamps()
    end
  end
end
