defmodule Evolution.Contexts.Measurements do
  @moduledoc """
  Measurements
  """

  alias Evolution.Contexts.Measurements.SkinFoldType
  alias Evolution.Core.Measurements.SkinFold
  alias Evolution.Core.Measurements.Validators
  alias Evolution.Repositories.Measurements.SkinFoldStore
  alias Evolution.Repositories.User

  @default_method "3 folds"

  def list_skin_folds(%User{} = user) do
    folds = SkinFoldStore.list_by_user(user.id)
    SkinFold.calculate_diffs(folds)
  end

  def register_skin_fold(%User{} = user, %SkinFoldType{} = attrs) do
    with {:ok, measurement_keys} <-
           Validators.validate_skin_fold_measurements(user, @default_method, attrs) do
      stats = SkinFold.calculate_folds(user, @default_method, attrs, measurement_keys)
      SkinFoldStore.create_skin_fold_with_weight(attrs, stats, user, @default_method)
    end
  end
end
