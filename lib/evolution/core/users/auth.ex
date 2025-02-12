defmodule Evolution.Core.Users.Auth do
  @moduledoc """
  User authentication functions.
  """
  alias Evolution.Crypt
  alias Evolution.Repositories.User.Store

  def authenticate(email, password) do
    user = Store.get_by_email(email)

    case user do
      nil ->
        {:error, "User not found"}

      _ ->
        case Crypt.check_hash(password, user.password_hash) do
          true -> {:ok, user}
          false -> {:error, "Invalid password"}
        end
    end
  end
end
