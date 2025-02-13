defmodule EvolutionWeb.Plugs.Auth do
  @moduledoc """
  Auth plug
  """
  alias Evolution.Core.Guardian

  import Plug.Conn
  

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, user} <- get_connection_token(conn) do
      assign(conn, :current_user, user)
    end
  end

  defp get_connection_token(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      {:ok, user}
    else
      _ -> {:error, :unauthorized}
    end
  end
end
