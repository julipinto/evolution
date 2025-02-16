defmodule Evolution.Core.Measurements.SkinFold do
  @moduledoc """
  SkinFold measurements
  """
  defstruct [
    :weight,
    :fat_percentage,
    :fat_classification,
    :fat_mass,
    :residual_mass,
    :lean_mass,
    :fold_sum,
    :body_density
  ]

  alias Evolution.Contexts.Measurements.SkinFoldType
  alias Evolution.Core.Measurements.FatClassification
  alias Evolution.Core.Users.Users
  alias Evolution.Repositories.Measurements.SkinFold
  alias Evolution.Repositories.User

  def calculate_folds(%User{gender: gender} = user, method, attrs, measurement_keys) do
    user_age = Users.get_age(user)

    density_stats =
      calculates_folds_sum_and_density(method, user_age, gender, attrs, measurement_keys)

    fat_percentage = calculate_fat_percentage(density_stats.body_density)

    %__MODULE__{
      weight: attrs.weight,
      fat_percentage: fat_percentage,
      fat_classification: FatClassification.classify(gender, user_age, fat_percentage),
      fat_mass: fat_mass(attrs.weight, fat_percentage),
      residual_mass: residual_mass(gender, attrs.weight),
      lean_mass: lean_mass(attrs.weight, fat_percentage),
      fold_sum: density_stats.fold_sum,
      body_density: density_stats.body_density
    }
  end

  def calculate_diff_from_last_measurement(nil, _folds),
    do: %{
      triceps_last_diff: nil,
      biceps_last_diff: nil,
      abdominal_last_diff: nil,
      subscapular_last_diff: nil,
      thigh_last_diff: nil,
      suprailiac_last_diff: nil
    }

  def calculate_diff_from_last_measurement(%SkinFold{} = last_m, %SkinFoldType{} = new_m) do
    %{
      triceps_last_diff: safe_subtract(last_m.triceps_fold, new_m.triceps_fold),
      biceps_last_diff: safe_subtract(last_m.biceps_fold, new_m.biceps_fold),
      abdominal_last_diff: safe_subtract(last_m.abdominal_fold, new_m.abdominal_fold),
      subscapular_last_diff: safe_subtract(last_m.subscapular_fold, new_m.subscapular_fold),
      thigh_last_diff: safe_subtract(last_m.thigh_fold, new_m.thigh_fold),
      suprailiac_last_diff: safe_subtract(last_m.suprailiac_fold, new_m.suprailiac_fold)
    }
  end

  defp safe_subtract(nil, _),
    do: nil

  defp safe_subtract(_, nil), do: nil

  defp safe_subtract(a, b), do: a - b

  defp calculates_folds_sum_and_density(method, age, gender, attrs, measurement_keys) do
    sum = sum_folds(attrs, measurement_keys)

    %{
      body_density: calculate_body_density(method, gender, age, sum),
      fold_sum: sum
    }
  end

  def calculate_body_density("3 folds", :female, age, sum) do
    1.0994921 - 0.0009929 * sum + 0.0000023 * :math.pow(sum, 2) - 0.0001392 * age
  end

  def calculate_body_density("3 folds", :male, age, sum) do
    1.10938 - 0.0008267 * sum + 0.0000016 * :math.pow(sum, 2) - 0.0002574 * age
  end

  def calculate_body_density("7 folds", :female, age, sum) do
    1.097 - 0.00046971 * sum + 0.00000056 * :math.pow(sum, 2) - 0.00012828 * age
  end

  def calculate_body_density("7 folds", :male, age, sum) do
    1.112 - 0.00043499 * sum + 0.00000055 * :math.pow(sum, 2) - 0.00028826 * age
  end

  def sum_folds(attrs, measurement_keys) do
    attrs
    |> Map.take(measurement_keys)
    |> Map.values()
    |> Enum.sum()
  end

  defp calculate_fat_percentage(body_density) do
    (4.57 / body_density - 4.142) * 100
  end

  defp residual_mass(:female, weight) do
    weight * 0.209
  end

  defp residual_mass(:male, weight) do
    weight * 0.328
  end

  defp fat_mass(weight, fat_percentage) do
    weight * fat_percentage / 100
  end

  defp lean_mass(weight, fat_percentage) do
    weight - fat_mass(weight, fat_percentage)
  end
end
