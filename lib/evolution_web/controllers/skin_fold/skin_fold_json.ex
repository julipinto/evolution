defmodule EvolutionWeb.SkinFoldJSON do
  @moduledoc """
  SkinFolders view
  """

  def index(%{skin_folds: skin_folds}) do
    %{skin_folds: for(skin_fold <- skin_folds, do: render_one_with_diffs(skin_fold))}
  end

  def render_one_with_diffs(skin_fold) do
    %{
      id: skin_fold.id,
      measurements: %{
        triceps: %{
          current: skin_fold.triceps_fold,
          last_diff: skin_fold.triceps_fold_diff
        },
        biceps: %{
          current: skin_fold.biceps_fold,
          last_diff: skin_fold.biceps_fold_diff
        },
        abdominal: %{
          current: skin_fold.abdominal_fold,
          last_diff: skin_fold.abdominal_fold_diff
        },
        subscapular: %{
          current: skin_fold.subscapular_fold,
          last_diff: skin_fold.subscapular_fold_diff
        },
        thigh: %{
          current: skin_fold.thigh_fold,
          last_diff: skin_fold.thigh_fold_diff
        },
        suprailiac: %{
          current: skin_fold.suprailiac_fold,
          last_diff: skin_fold.suprailiac_fold_diff
        },
        middle_axillary: %{
          current: skin_fold.middle_axillary_fold,
          last_diff: skin_fold.middle_axillary_fold_diff
        },
        calf: %{
          current: skin_fold.calf_fold,
          last_diff: skin_fold.calf_fold_diff
        }
      },
      stats: %{
        weight: %{
          current: skin_fold.weight,
          last_diff: skin_fold.weight_diff
        },
        fat_percentage: %{
          current: skin_fold.fat_percentage,
          last_diff: skin_fold.fat_percentage_diff
        },
        lean_mass: %{
          current: skin_fold.lean_mass,
          last_diff: skin_fold.lean_mass_diff
        },
        fat_mass: %{
          current: skin_fold.fat_mass,
          last_diff: skin_fold.fat_mass_diff
        },
        fat_classification: skin_fold.fat_classification,
        residual_mass: %{
          current: skin_fold.residual_mass,
          last_diff: skin_fold.residual_mass_diff
        },
        body_density: %{
          current: skin_fold.body_density,
          last_diff: skin_fold.body_density_diff
        }
      },
      measured_at: skin_fold.measured_at,
      measured_by: skin_fold.measured_by
    }
  end

  def show(%{skin_fold: skin_fold}) do
    %{skin_fold: render_one(skin_fold)}
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
        suprailiac: skin_fold.suprailiac_fold,
        middle_axillary: skin_fold.middle_axillary_fold,
        calf: skin_fold.calf_fold
      },
      stats: %{
        weight: skin_fold.weight.value,
        fat_percentage: skin_fold.fat_percentage,
        lean_mass: skin_fold.lean_mass,
        fat_mass: skin_fold.fat_mass,
        fat_classification: skin_fold.fat_classification,
        residual_mass: skin_fold.residual_mass,
        body_density: skin_fold.body_density
      },
      measured_at: skin_fold.measured_at,
      measured_by: skin_fold.measured_by
    }
  end
end
