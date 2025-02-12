defmodule EvolutionWeb.Controllers.SkinFold do
  @moduledoc """
  SkinFold controller
  """
  use EvolutionWeb, :controller

  alias Evolution.Contexts.Measurements
  alias Evolution.Contexts.Measurements.Input

  def create(conn, attrs) do
    user = conn.assigns.current_user
    attrs = Map.merge(skin_fold_params, %{"user_id" => user.id})
    input = %Input{attrs}

    #   case Measurements.register_skin_fold(user, input) do
    #     {:ok, _} ->
    #       conn
    #       |> put_flash(:info, "Skin fold measurement registered")
    #       |> redirect(to: Routes.user_path(conn, :show, user))

    #     {:error, %Ecto.Changeset{} = changeset} ->
    #       conn
    #       |> put_flash(:error, "Error registering skin fold measurement")
    #       |> render("new.html", changeset: changeset)
    #   end
  end
end
