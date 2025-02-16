defmodule EvolutionWeb.Controllers.AuthControllerTest do
  use EvolutionWeb.ConnCase

  alias Evolution.Core.Crypt
  alias Evolution.Fixtures.UserFixture

  setup %{conn: conn} do
    email = "email@mail.com"
    password_hash = Crypt.hash("password")

    user =
      UserFixture.create_user(%{
        email: email,
        password_hash: password_hash
      })

    {:ok, conn: conn, user: user, email: email, password: "password"}
  end

  test "authenticate with valid credentials", %{conn: conn, email: email, password: password} do
    conn = post(conn, "/auth", %{email: email, password: password})
    assert json_response(conn, 200)["token"]
  end

  test "authenticate with invalid credentials", %{conn: conn, email: email} do
    conn = post(conn, "/auth", %{email: email, password: "wrong_password"})
    assert json_response(conn, 401)["error"] == "Invalid credentials"
  end

  test "authenticate with invalid email", %{conn: conn} do
    conn = post(conn, "/auth", %{email: "wrong_email@mail.com", password: "password"})
    assert json_response(conn, 401)["error"] == "Invalid credentials"
  end
end
