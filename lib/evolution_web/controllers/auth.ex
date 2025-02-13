defmodule EvolutionWeb.Controllers.AuthController do
  use EvolutionWeb, :controller

  alias Evolution.Core.Users.Auth

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate(email, password) do
      {:ok, token} -> conn |> put_status(:ok) |> json(%{token: token})
      {:error, reason} -> conn |> put_status(:unauthorized) |> json(%{error: reason})
    end
  end
end