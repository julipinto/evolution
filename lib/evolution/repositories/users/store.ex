defmodule Evolution.Repositories.User.Store do
  @moduledoc """
  User store functions.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.User

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_by_id(id) do
    Repo.get(User, id)
  end
end
