defmodule EvolutionWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use EvolutionWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Evolution.Core.Guardian

  using do
    quote do
      # The default endpoint for testing
      @endpoint EvolutionWeb.Endpoint

      use EvolutionWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import EvolutionWeb.ConnCase
    end
  end

  setup tags do
    Evolution.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  This function is used to simulate an authenticated user

  * ATENTION: it won't validate credentials, it will only
  * set the authorization header with a valid token 
  """
  def authenticate(conn, user) do
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{get_user_token(user)}")
  end

  def get_user_token(user) do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(%{id: user.id}, %{}, ttl: {20, :seconds})
    jwt
  end
end
