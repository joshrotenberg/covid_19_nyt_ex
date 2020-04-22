defmodule Covid19.Repo.Migrations.AddZipCodesConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:zip_codes, [:zip, :fips], name: :zip_codes_zip_fips_index)
  end
end
