defmodule Evolution.Core.Users.Users do
  @moduledoc """
  Users
  """

  alias Evolution.Repositories.User

  def get_age(%User{birthdate: birthdate}) do
    today = Date.utc_today()

    years = today.year - birthdate.year

    if Date.compare(today, %{birthdate | year: today.year}) == :lt do
      years - 1
    else
      years
    end
  end
end
