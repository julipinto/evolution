defmodule Evolution.Contexts.Measurements.SkinFoldType do
  @moduledoc """
  Input for measurements
  """
  defstruct [
    :triceps_fold,
    :biceps_fold,
    :abdominal_fold,
    :subscapular_fold,
    :thigh_fold,
    :suprailiac_fold,
    :weight,
    :measured_at,
    :measured_by
  ]

  def to_type(input) do
    %__MODULE__{
      triceps_fold: Map.get(input, :triceps),
      biceps_fold: Map.get(input, :biceps),
      abdominal_fold: Map.get(input, :abdominal),
      subscapular_fold: Map.get(input, :subscapular),
      thigh_fold: Map.get(input, :thigh),
      suprailiac_fold: Map.get(input, :suprailiac),
      middle_axillary_fold: Map.get(input, :middle_axillary),
      calf_fold: Map.get(input, :calf),
      weight: Map.get(input, :weight),
      measured_at: Map.get(input, :measured_at),
      measured_by: Map.get(input, :measured_by)
    }
  end
end
