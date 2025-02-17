defmodule Evolution.Repo.Migrations.CreateTableWeights do
  use Ecto.Migration

  def up do
    create table :weights do
      add :value, :float, null: false
      add :measured_at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
