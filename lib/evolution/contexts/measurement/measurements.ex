defmodule Evolution.Contexts.Measurements do
  @moduledoc """
  Measurements
  """

  alias Evolution.Contexts.Measurements.Input
  alias Evolution.Core.Measurements.SkinFold
  alias Evolution.Repositories.Measurement.SkinFolds.Store
  alias Evolution.Repositories.User

  @method "3"

  def register_skin_fold(%User{} = user, %Input{} = attrs) do
    last_measurement = Store.get_last_measurement_from_user(user.id)
    diff = SkinFold.diff(last_measurement, attrs)
    stats = SkinFold.calculate(user, @method, attrs)

    measurement =
      attrs
      |> Map.merge(diff)
      |> Map.merge(stats)
      |> Map.merge(%{user_id: user.id})
      |> Map.put(:method, @method)

    with {:ok, fold} <- Store.create(measurement) do
      fold
    end
  end
end
