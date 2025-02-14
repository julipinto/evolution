defmodule Evolution.Fixtures.SkinFoldsFixture do
  @moduledoc """
  This module defines the skin folds fixture.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.Measurements.SkinFold

  def create_skin_folds(user_id) do
    %{
      weight: 75.5,
      triceps_fold: 12.4,
      biceps_fold: 8.3,
      abdominal_fold: 18.7,
      subscapular_fold: 14.2,
      thigh_fold: 16.1,
      suprailiac_fold: 10.5,
      triceps_last_diff: -0.5,
      biceps_last_diff: 0.2,
      abdominal_last_diff: -1.0,
      subscapular_last_diff: 0.4,
      thigh_last_diff: -0.3,
      suprailiac_last_diff: -0.7,
      fat_percentage: 15.8,
      fat_classification: "Athletic",
      fat_mass: 12.0,
      residual_mass: 10.5,
      lean_mass: 53.0,
      fold_sum: 80.2,
      body_density: 1.065,
      method: "Jackson-Pollock 7-Site",
      measured_at: ~D[2025-02-14],
      user_id: user_id
    }
    |> SkinFold.changeset()
    |> Repo.insert!()
  end
end
