defmodule Evolution.Repositories.Measurement.SkinFolds.Store do
  @moduledoc """
  Store module for the SkinFolds measurement.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.Measurements.SkinFold

  import Ecto.Query

  def create(%SkinFold{} = skin_fold) do
    skin_fold
    |> SkinFold.changeset()
    |> Repo.insert()
  end

  def update(%SkinFold{} = skin_fold) do
    skin_fold
    |> SkinFold.changeset()
    |> Repo.update()
  end

  def delete(%SkinFold{} = skin_fold) do
    Repo.delete(skin_fold)
  end

  def get_last_measurement_from_user(user_id) do
    from(skin_fold in SkinFold,
      where: skin_fold.user_id == ^user_id,
      order_by: [desc: skin_fold.measured_at],
      limit: 1
    )
    |> Repo.one()
  end

  def list_by_user(user_id) do
    from(skin_fold in SkinFold,
      where: skin_fold.user_id == ^user_id,
      order_by: [desc: skin_fold.measured_at]
    )
    |> Repo.all()
  end
end
