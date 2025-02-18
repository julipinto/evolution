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

  @diff_fields [
    :weight,
    :triceps_fold,
    :biceps_fold,
    :abdominal_fold,
    :subscapular_fold,
    :thigh_fold,
    :suprailiac_fold,
    :middle_axillary_fold,
    :calf_fold,
    :fat_percentage,
    :fat_mass,
    :residual_mass,
    :lean_mass,
    :fold_sum,
    :body_density
  ]

  alias Evolution.Core.Measurements.FatClassification
  alias Evolution.Core.Users.Users
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

  # takes an list in descending order of measurements and calculates the difference between each measurement
  def calculate_diffs(folds) when is_list(folds) do
    folds
    |> Enum.map(&normalize_weight/1)
    |> Enum.with_index()
    |> Enum.map(fn {fold, index} ->
      if index == length(folds) - 1 do
        add_nil_diffs(fold)
      else
        previous_fold = Enum.at(folds, index + 1)
        add_diffs(fold, previous_fold)
      end
    end)
  end

  defp normalize_weight(fold) do
    Map.put(fold, :weight, fold.weight.value)
  end

  defp add_nil_diffs(fold) do
    Enum.reduce(@diff_fields, fold, fn field, acc ->
      Map.put(acc, :"#{field}_diff", nil)
    end)
  end

  defp add_diffs(current_fold, previews_fold) do
    Enum.reduce(@diff_fields, current_fold, fn field, acc ->
      Map.put(acc, :"#{field}_diff", safe_subtract(current_fold[field], previews_fold[field]))
    end)
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
