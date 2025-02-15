defmodule Evolution.Repositories.Measurements.SkinFold do
  @moduledoc """
  SkinFold measurements
  """
  import Ecto.Changeset

  use Ecto.Schema

  alias Evolution.Repositories.User

  @fields [
    :weight,
    :triceps_fold,
    :biceps_fold,
    :abdominal_fold,
    :subscapular_fold,
    :thigh_fold,
    :suprailiac_fold,
    :triceps_last_diff,
    :biceps_last_diff,
    :abdominal_last_diff,
    :subscapular_last_diff,
    :thigh_last_diff,
    :suprailiac_last_diff,
    :method,
    :fat_percentage,
    :fat_classification,
    :fat_mass,
    :residual_mass,
    :lean_mass,
    :fold_sum,
    :body_density,
    :measured_at,
    :user_id
  ]

  @required_fields [
    :triceps_fold,
    :biceps_fold,
    :abdominal_fold,
    :subscapular_fold,
    :thigh_fold,
    :suprailiac_fold,
    :method,
    :user_id
  ]

  schema "skin_folds" do
    field :weight, :float

    field :triceps_fold, :float
    field :biceps_fold, :float
    field :abdominal_fold, :float
    field :subscapular_fold, :float
    field :thigh_fold, :float
    field :suprailiac_fold, :float

    field :triceps_last_diff, :float
    field :biceps_last_diff, :float
    field :abdominal_last_diff, :float
    field :subscapular_last_diff, :float
    field :thigh_last_diff, :float
    field :suprailiac_last_diff, :float

    field :fat_percentage, :float
    field :fat_classification, :string
    field :fat_mass, :float
    field :residual_mass, :float
    field :lean_mass, :float
    field :fold_sum, :float
    field :body_density, :float

    field :method, :string
    field :measured_at, :date

    belongs_to :user, User

    timestamps()
  end

  def changeset(skin_fold \\ %__MODULE__{}, attrs) do
    skin_fold
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> measured_at()
  end

  def measured_at(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :measured_at) do
      nil -> put_change(changeset, :measured_at, Date.utc_today())
      _ -> changeset
    end
  end

  def measured_at(changeset), do: changeset
end
