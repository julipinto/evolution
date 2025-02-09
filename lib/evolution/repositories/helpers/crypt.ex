defmodule Evolution.Repositories.Helpers.Crypt do
  @moduledoc """
  Crypt helper functions.
  """

  import Comeonin.Bcrypt, only: [checkpw: 2, hashpw: 1]

  @doc """
  Hashes a password.
  """
  @spec hash(String.t()) :: String.t()
  def hash(password) do
    hashpw(password)
  end

  @doc """
  Checks if a password is correct.
  """
  @spec check_hash(String.t(), String.t()) :: boolean()
  def check_hash(password, hash) do
    checkpw(password, hash)
  end
end
