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
      }
    }
  end
end
