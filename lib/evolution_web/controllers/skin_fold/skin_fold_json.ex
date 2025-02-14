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
        triceps: skin_fold.triceps,
        subscapular: skin_fold.subscapular,
        abdominal: skin_fold.abdominal,
        suprailiac: skin_fold.suprailiac,
        thigh: skin_fold.thigh,
        chest: skin_fold.chest,
        axilla: skin_fold.axilla
      }
    }
  end
end
