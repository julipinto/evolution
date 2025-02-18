defmodule Evolution.Repositories.Measurements.WeightStore do
  @moduledoc """
  Store module for the SkinFolds measurement.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.Measurements.Weight

  def create!(weight) do
    weight
    |> Weight.changeset()
    |> Repo.insert!()
  end
end
