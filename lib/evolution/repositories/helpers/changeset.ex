defmodule Evolution.Repositories.Helpers.Changeset do
  @moduledoc """
  Changeset helper functions.
  """

  import Ecto.Changeset

  alias Evolution.Repositories.Helpers.Crypt

  @email_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

  @doc """
  Validates the email field in a changeset.
  The validation is done by checking the length and format of the email.

  Length validation is based on RFC 3696 "Application Techniques for 
  Checking and Transformation of Names" Section 3. 

  You can see more here: https://www.rfc-editor.org/rfc/rfc3696#section-3

  ## Examples

      iex> email_changeset(%Ecto.Changeset{}, :email)
      %Ecto.Changeset{}

  """
  @spec email_changeset(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def email_changeset(changeset, key \\ :email) do
    changeset
    |> validate_length(key,
      min: 5,
      max: 256,
      message: "email length must be between 5 and 256 characters"
    )
    |> validate_format(key, @email_regex, message: "invalid email format")
  end

  @doc """
  Validates the password field in a changeset.

  ## Examples

      iex> validate_password(%Ecto.Changeset{}, :password)
      %Ecto.Changeset{}

  """
  def password_changeset(
        %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset,
        key \\ :password_hash
      )
      when password != nil do
    password_hash = Crypt.hash(password)
    Map.put_new(changeset.changes, key, password_hash)
  end

  def password_changeset(changeset, _key_from, _key_to), do: changeset
end
