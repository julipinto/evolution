defmodule Evolution.Contexts.Measurements do
  @moduledoc """
  Measurements
  """

  alias Evolution.Contexts.Measurements.SkinFoldType
  alias Evolution.Core.Measurements.SkinFold
  alias Evolution.Repositories.Measurement.SkinFolds.Store
  alias Evolution.Repositories.User

  @method "3"

  def list_skin_folds(%User{} = user) do
    Store.list_by_user(user.id)
  end

  def register_skin_fold(%User{} = user, %SkinFoldType{} = attrs) do
    last_measurement = Store.get_last_measurement_from_user(user.id)
    diff = SkinFold.diff(last_measurement, attrs)
    stats = SkinFold.calculate(user, @method, attrs)

    measurement =
      attrs
      |> Map.merge(diff)
      |> Map.merge(stats)
      |> Map.merge(%{user_id: user.id})
      |> Map.put(:method, @method)
      |> IO.inspect()

    Store.create(measurement)
  end
end
