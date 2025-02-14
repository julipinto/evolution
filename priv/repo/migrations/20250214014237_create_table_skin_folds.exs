defmodule Evolution.Repo.Migrations.CreateTableSkinFolds do
  @moduledoc false
  use Ecto.Migration

  def up do
    create table(:skin_folds) do
      add :weight, :float
      
      add :triceps_fold, :float
      add :biceps_fold, :float
      add :abdominal_fold, :float
      add :subscapular_fold, :float
      add :thigh_fold, :float
      add :suprailiac_fold, :float

      add :triceps_last_diff, :float
      add :biceps_last_diff, :float
      add :abdominal_last_diff, :float
      add :subscapular_last_diff, :float
      add :thigh_last_diff, :float
      add :suprailiac_last_diff, :float

      add :fat_percentage, :float
      add :fat_classification, :string
      add :fat_mass, :float
      add :residual_mass, :float
      add :lean_mass, :float
      add :fold_sum, :float
      add :body_density, :float
    
      add :method, :string
      add :measured_at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end

  def down, do: nil
end
