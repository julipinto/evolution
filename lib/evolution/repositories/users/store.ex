defmodule Evolution.Repositories.User.Store do
  @moduledoc """
  User store functions.
  """
  alias Evolution.Repositories.User
  alias Evolution.Repo

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
