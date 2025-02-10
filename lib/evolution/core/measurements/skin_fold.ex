defmodule Evolution.Core.Measurements.SkinFold do
  @moduledoc """
  SkinFold measurements
  """
  defstruct [
    :body_density,
    :fold_sum,
    :body_fat_percentage,
    :weight,
    :residual_mass,
    :fat_mass,
    :lean_mass
  ]

  alias Evolution.Core.Measurements.FatClassification
  alias Evolution.Core.Users.Users

  def calculate(%User{gender: gender} = user, method, folds, weight) do
    user_age = Users.get_age(user)

    density_stats =
      case method do
        "3" -> calculate_3_folds_density(user_age, gender, folds)
        "7" -> calculate_7_folds_density(user_age, gender, folds)
      end

    body_fat_percentage = calculate_body_fat_percentage(density_stats.body_density)

    %__MODULE__{
      body_density: density_stats.body_density,
      fold_sum: density_stats.fold_sum,
      body_fat_percentage: body_fat_percentage,
      weight: weight,
      residual_mass: residual_mass(gender, weight),
      fat_mass: fat_mass(weight, body_fat_percentage),
      lean_mass: lean_mass(weight, body_fat_percentage),
      fat_classification: FatClassification.classify(gender, user_age, body_fat_percentage)
    }
  end

  defp calculate_3_folds_density(age, :female, folds) do
    sum = 0

    %{
      body_density: 1.0994921 - 0.0009929 * sum + :math.pow(0.0000023, 2) - 0.0001392 * age,
      fold_sum: sum
    }
  end

  # defp calculate_3_folds_density(age, :male, folds) do
  #   _pass
  # end

  defp calculate_7_folds_density(age, :female, folds) do
    sum = 0

    %{
      body_density: 1.097 - 0.00046971 * sum + :math.pow(0.00000056, 2) - 0.00012828 * age,
      fold_sum: sum
    }
  end

  # defp calculate_7_folds_density(age, :male, folds) do
  #   _pass
  # end

  defp calculate_body_fat_percentage(body_density) do
    (4.95 / body_density - 4.5) * 100
  end

  defp residual_mass(:female, weight) do
    weight * 0.2087
  end

  defp residual_mass(:male, weight) do
    weight * 0.328
  end

  defp fat_mass(weight, body_fat_percentage) do
    weight * body_fat_percentage / 100
  end

  defp lean_mass(weight, body_fat_percentage) do
    weight - fat_mass(weight, body_fat_percentage)
  end
end
