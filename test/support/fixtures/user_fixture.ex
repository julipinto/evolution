defmodule Evolution.Fixtures.UserFixture do
  @moduledoc """
  This module defines the user fixture.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.User

  def create_user(attrs \\ %{}) do
    attrs
    |> Map.merge(%{
      name: "John",
      last_name: "Doe",
      email: "test@test.com",
      birthdate: ~D[1990-01-01],
      password_hash: Bcrypt.hash_pwd_salt("password"),
      gender: :female
    })
    |> User.changeset()
    |> Repo.insert!()
  end
end
