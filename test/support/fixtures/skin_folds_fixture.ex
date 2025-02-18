defmodule Evolution.Fixtures.SkinFoldsFixture do
  @moduledoc """
  This module defines the skin folds fixture.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.Measurements.SkinFold
  alias Evolution.Fixtures.WeightFixture

  def create_skin_folds(user_id, attrs \\ %{}) do
    weight_value = Map.get(attrs, :weight, 75.5)

    weight_attrs =
      attrs
      |> Map.take([:measured_at])
      |> Map.put(:value, weight_value)

    weight = WeightFixture.create_weight(user_id, weight_attrs)

    %{
      triceps_fold: 12.4,
      biceps_fold: 8.3,
      abdominal_fold: 18.7,
      subscapular_fold: 14.2,
      thigh_fold: 16.1,
      suprailiac_fold: 10.5,
      middle_axillary_fold: 8.0,
      calf_fold: 6.0,
      fat_percentage: 15.8,
      fat_classification: "Athletic",
      fat_mass: 12.0,
      residual_mass: 10.5,
      lean_mass: 53.0,
      fold_sum: 80.2,
      body_density: 1.065,
      method: "Jackson-Pollock 7-Site",
      measured_at: ~D[2025-02-14],
      measured_by: "John Doe",
      weight_id: weight.id,
      user_id: user_id
    }
    |> Map.merge(attrs)
    |> SkinFold.changeset()
    |> Repo.insert!()
  end
end
