defmodule Evolution.Core.Users.Auth do
  @moduledoc """
  User authentication functions.
  """
  alias Evolution.Core.Crypt
  alias Evolution.Core.Guardian
  alias Evolution.Repositories.User.Store

  @ttl {30, :days}

  def authenticate(email, password) do
    user = Store.get_by_email(email)

    case user do
      nil -> {:error, "User not found"}
      user -> check_and_sign_in(user, password)
    end
  end

  def check_and_sign_in(user, password) do
    case Crypt.check_hash(password, user.password_hash) do
      false -> {:error, "Invalid credentials"}
      true -> sign_in(user.id)
    end
  end

  def sign_in(user_id) do
    with {:ok, token, _claims} <- Guardian.encode_and_sign(%{id: user_id}, %{}, ttl: {20, :days}) do
      {:ok, token}
    end
  end
end
