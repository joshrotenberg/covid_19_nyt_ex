defmodule Covid19.Repo.Migrations.AddStateConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:states, [:date, :state], name: :states_date_state_index)
  end
end
