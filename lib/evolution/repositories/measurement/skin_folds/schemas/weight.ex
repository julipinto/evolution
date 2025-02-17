defmodule Evolution.Repositories.Measurements.Weight do
  @moduledoc """
  Weight measurements
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :value,
    :measured_at,
    :user_id
  ]

  @required_fields [
    :value,
    :user_id
  ]

  schema "weights" do
    field :value, :float
    field :measured_at, :date
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(weight, attrs) do
    weight
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
  end
end
