defmodule Evolution.Core.Measurements.Validators do
  alias Evolution.Repositories.User

  def validate_skin_fold_measurements(user, method, attrs) do
    measurement_keys = get_measurement_sum_keys(user, method)

    case attrs_has_measurements?(attrs, measurement_keys) do
      true -> {:ok, measurement_keys}
      false -> {:error, "Invalid measurements"}
    end
  end

  defp get_measurement_sum_keys(%User{gender: :female}, "3 folds") do
    [:triceps_fold, :suprailiac_fold, :thigh_fold]
  end

  defp get_measurement_sum_keys(%User{gender: :male}, "3 folds") do
    [:triceps_fold, :chest_fold, :abdominal_fold]
  end

  defp get_measurement_sum_keys(_user, "7 folds") do
    [
      :triceps_fold,
      :subscapular_fold,
      :medium_axillary_fold,
      :suprailiac_fold,
      :abdominal_fold,
      :thigh_fold,
      :calf_fold
    ]
  end

  defp attrs_has_measurements?(attrs, measurement_keys) do
    Enum.all?(measurement_keys, fn key ->
      case Map.fetch(attrs, key) do
        {:ok, value} -> is_number(value)
        :error -> false
      end
    end)
  end
end
