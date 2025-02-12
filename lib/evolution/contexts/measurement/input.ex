defmodule Evolution.Contexts.Measurements.Input do
  @moduledoc """
  Input for measurements
  """
  @enforce_keys [
    :triceps_fold,
    :biceps_fold,
    :abdominal_fold,
    :subscapular_fold,
    :thigh_fold,
    :suprailiac_fold,
    :weight
  ]

  defstruct [
    :triceps_fold,
    :biceps_fold,
    :abdominal_fold,
    :subscapular_fold,
    :thigh_fold,
    :suprailiac_fold,
    :weight,
    :measured_at
  ]
end
