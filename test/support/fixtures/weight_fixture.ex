defmodule Evolution.Fixtures.WeightFixture do
  @moduledoc """
  This module defines the skin folds fixture.
  """
  alias Evolution.Repo
  alias Evolution.Repositories.Measurements.Weight

  def create_weight(user_id, attrs \\ %{}) do
    %{
      value: 75.5,
      measured_at: ~D[2025-02-14],
      user_id: user_id
    }
    |> Map.merge(attrs)
    |> Weight.changeset()
    |> Repo.insert!()
  end
end
