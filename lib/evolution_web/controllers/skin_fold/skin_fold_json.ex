defmodule EvolutionWeb.SkinFoldJSON do
  @moduledoc """
  SkinFolders view
  """

  def index(%{skin_folds: skin_folds}) do
    %{skin_folds: for(skin_fold <- skin_folds, do: render_one(skin_fold))}
  end

  def render_one(skin_fold) do
    %{
      id: skin_fold.id,
      measurements: %{
        triceps: skin_fold.triceps_fold,
        biceps: skin_fold.biceps_fold,
        abdominal: skin_fold.abdominal_fold,
        subscapular: skin_fold.subscapular_fold,
        thigh: skin_fold.thigh_fold,
        suprailiac: skin_fold.suprailiac_fold
      },
      diffs: %{
        triceps: skin_fold.triceps_last_diff,
        biceps: skin_fold.biceps_last_diff,
        abdominal: skin_fold.abdominal_last_diff,
        subscapular: skin_fold.subscapular_last_diff,
        thigh: skin_fold.thigh_last_diff,
        suprailiac: skin_fold.suprailiac_last_diff
      },
      stats: %{
        weight: skin_fold.weight,
        fat_percentage: skin_fold.fat_percentage,
        lean_mass: skin_fold.lean_mass,
        fat_mass: skin_fold.fat_mass,
        fat_classification: skin_fold.fat_classification,
        residual_mass: skin_fold.residual_mass,
        body_density: skin_fold.body_density
      },
      measured_at: skin_fold.measured_at
    }
  end

  def show(%{skin_fold: skin_fold}) do
    %{skin_fold: render_one(skin_fold)}
  end
end
