defmodule Evolution.Core.Crypt do
  @moduledoc """
  Crypt helper functions.
  """

  @doc """
  Hashes a password.
  """
  @spec hash(String.t()) :: String.t()
  def hash(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  @doc """
  Checks if a password is correct.
  """
  @spec check_hash(String.t(), String.t()) :: boolean()
  def check_hash(password, hash) do
    Bcrypt.verify_pass(password, hash)
  end
end
