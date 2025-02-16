defmodule EvolutionWeb.Controllers.FallbackController do
  use EvolutionWeb, :controller

  def call(conn, {:error, :invalid_params}) do
    conn
    |> put_status(:bad_request)
    |> put_view(EvolutionWeb.ErrorJSON)
    |> render("400.json", %{})
  end
end
