defmodule Evolution.Core.Users.Users do
  @moduledoc """
  Users
  """

  alias Evolution.Repositories.Users.Schemas.User

  def get_age(%User{birthdate: birthdate}) do
    {:ok, age} = Date.diff(Date.utc_today(), birthdate, :years)
    age
  end
end
