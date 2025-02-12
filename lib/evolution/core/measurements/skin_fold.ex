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

  alias Evolution.Core.Measurements.FatClassification
  alias Evolution.Core.Users.Users
  alias Evolution.Repositories.Measurements.SkinFold
  alias Evolution.Repositories.User

  def calculate(%User{gender: gender} = user, method, attrs) do
    user_age = Users.get_age(user)

    density_stats =
      case method do
        "3" -> calculate_3_folds_density(user_age, gender, attrs)
        "7" -> calculate_7_folds_density(user_age, gender, attrs)
      end

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

  def diff(nil, _folds),
    do: %{
      triceps_last_diff: nil,
      biceps_last_diff: nil,
      abdominal_last_diff: nil,
      subscapular_last_diff: nil,
      thigh_last_diff: nil,
      suprailiac_last_diff: nil
    }

  def diff(%SkinFold{} = skin_fold, folds) do
    %{
      triceps_last_diff: skin_fold.triceps_fold - folds.triceps_fold,
      biceps_last_diff: skin_fold.biceps_fold - folds.biceps_fold,
      abdominal_last_diff: skin_fold.abdominal_fold - folds.abdominal_fold,
      subscapular_last_diff: skin_fold.subscapular_fold - folds.subscapular_fold,
      thigh_last_diff: skin_fold.thigh_fold - folds.thigh_fold,
      suprailiac_last_diff: skin_fold.suprailiac_fold - folds.suprailiac_fold
    }
  end

  defp calculate_3_folds_density(age, :female, attrs) do
    sum = sum_folds(attrs, "3")

    %{
      body_density: 1.0994921 - 0.0009929 * sum + :math.pow(0.0000023, 2) - 0.0001392 * age,
      fold_sum: sum
    }
  end

  # defp calculate_3_folds_density(age, :male, attrs) do
  #   _pass
  # end

  defp calculate_7_folds_density(age, :female, attrs) do
    sum = sum_folds(attrs, "7")

    %{
      body_density: 1.097 - 0.00046971 * sum + :math.pow(0.00000056, 2) - 0.00012828 * age,
      fold_sum: sum
    }
  end

  # defp calculate_7_folds_density(age, :male, attrs) do
  #   _pass
  # end

  def sum_folds(
        %{
          triceps_fold: triceps_fold,
          biceps_fold: biceps_fold,
          abdominal_fold: abdominal_fold,
          subscapular_fold: subscapular_fold,
          thigh_fold: thigh_fold,
          suprailiac_fold: suprailiac_fold
        },
        "3"
      ) do
    triceps_fold + biceps_fold + abdominal_fold + subscapular_fold + thigh_fold + suprailiac_fold
  end

  def sum_folds(_attrs, _method),
    do: 0

  defp calculate_fat_percentage(body_density) do
    (4.95 / body_density - 4.5) * 100
  end

  defp residual_mass(:female, weight) do
    weight * 0.2087
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
