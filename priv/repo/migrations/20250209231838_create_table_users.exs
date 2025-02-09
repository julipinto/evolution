defmodule Evolution.Repo.Migrations.CreateTableUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name, :string
      add :last_name, :string
      add :email, :string
      add :password_hash, :string
      add :birthdate, :date

      timestamps()
    end
  end

  def down, do: nil
end
