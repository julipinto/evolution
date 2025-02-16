# defmodule EvolutionWeb.Controllers.SkinFoldController do
defmodule EvolutionWeb.SkinFoldController do
  @moduledoc """
  SkinFold controller
  """
  use EvolutionWeb, :controller

  alias Evolution.Contexts.Measurements
  alias Evolution.Contexts.Measurements.SkinFoldType

  action_fallback(EvolutionWeb.Controllers.FallbackController)

  def index(conn, _params) do
    user = conn.assigns.current_user
    skin_folds = Measurements.list_skin_folds(user)

    conn
    |> put_status(:ok)
    |> render(:index, skin_folds: skin_folds)
  end

  def create(%{assigns: %{current_user: user}} = conn, attrs) do
    measurement =
      SkinFoldType.to_type(%{
        triceps: Map.get(attrs, "triceps"),
        biceps: Map.get(attrs, "biceps"),
        abdominal: Map.get(attrs, "abdominal"),
        subscapular: Map.get(attrs, "subscapular"),
        thigh: Map.get(attrs, "thigh"),
        suprailiac: Map.get(attrs, "suprailiac"),
        weight: Map.get(attrs, "weight"),
        measured_at: Map.get(attrs, "measured_at")
      })

    with {:ok, skin_fold} <- Measurements.register_skin_fold(user, measurement) do
      conn
      |> put_status(:created)
      |> render("show.json", skin_fold: skin_fold)
    end
  end
end
