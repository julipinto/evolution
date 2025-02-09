defmodule Evolution.Repositories.User.Schemas.User do
  @moduledoc """
  User schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Evolution.Repositories.Helpers.Changeset

  @fields ~w(name last_name email birthdate password_hash)a
  @required_fields ~w(name email birthdate)a

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :birthdate, :date

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> Changeset.email_changeset()
    |> Changeset.password_changeset()
    |> unique_constraint(:email)
  end
end
