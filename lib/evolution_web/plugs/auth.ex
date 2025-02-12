defmodule EvolutionWeb.Plugs.Auth do
  @moduledoc """
  Auth plug
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token} <- get_connection_token(conn) do
      conn
      |> assign(:current_user, token)
    end
  end

  defp get_connection_token(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      {:ok, token}
    else
      _ -> {:error, "unauthorized"}
    end
  end
end
