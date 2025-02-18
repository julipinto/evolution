defmodule Evolution.Repositories.Measurements.SkinFoldStore do
  @moduledoc """
  Store module for the SkinFolds measurement.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.Measurements.SkinFold
  alias Evolution.Repositories.Measurements.WeightStore

  import Ecto.Query

  def create_skin_fold_with_weight(attrs, stats, user, method) do
    Repo.transaction(fn ->
      weight_params =
        attrs
        |> Map.take([:measured_at])
        |> Map.put(:user_id, user.id)
        |> Map.put(:value, attrs.weight)

      weight = WeightStore.create!(weight_params)

      attrs
      |> Map.merge(stats)
      |> Map.merge(%{user_id: user.id})
      |> Map.put(:method, method)
      |> Map.put(:weight_id, weight.id)
      |> Map.from_struct()
      |> SkinFold.changeset()
      |> Repo.insert!()
      |> Repo.preload(:weight)
    end)
  end

  def update(skin_fold) do
    skin_fold
    |> Map.from_struct()
    |> SkinFold.changeset()
    |> Repo.update()
  end

  def delete(skin_fold) do
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
      left_join: w in assoc(skin_fold, :weight),
      where: skin_fold.user_id == ^user_id,
      order_by: [desc: skin_fold.measured_at]
    )
    |> Repo.all()
    |> Repo.preload(:weight)
  end
end
