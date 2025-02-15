defmodule Evolution.Core.Measurements.FatClassification do
  @moduledoc """
  Module for classifying body fat percentage based on age and gender.
  """

  @classification_tables %{
    male: [
      %{
        age_range: 18..25,
        classifications: [
          excellent: 4..6,
          good: 7..10,
          adequate: 11..13,
          moderately_high: 14..16,
          high: 17..20,
          very_high: 21..24
        ]
      },
      %{
        age_range: 26..35,
        classifications: [
          excellent: 8..11,
          good: 12..15,
          adequate: 16..18,
          moderately_high: 19..20,
          high: 21..24,
          very_high: 25..27
        ]
      },
      %{
        age_range: 36..45,
        classifications: [
          excellent: 10..14,
          good: 15..18,
          adequate: 19..21,
          moderately_high: 22..23,
          high: 24..25,
          very_high: 26..29
        ]
      },
      %{
        age_range: 46..55,
        classifications: [
          excellent: 12..16,
          good: 17..20,
          adequate: 21..23,
          moderately_high: 24..25,
          high: 26..27,
          very_high: 28..30
        ]
      },
      %{
        age_range: 56..65,
        classifications: [
          excellent: 13..18,
          good: 19..21,
          adequate: 22..23,
          moderately_high: 24..25,
          high: 26..27,
          very_high: 28..30
        ]
      }
    ],
    female: [
      %{
        age_range: 18..25,
        classifications: [
          excellent: 13..16,
          good: 17..19,
          adequate: 20..22,
          moderately_high: 23..25,
          high: 26..28,
          very_high: 29..31
        ]
      },
      %{
        age_range: 26..35,
        classifications: [
          excellent: 14..16,
          good: 18..20,
          adequate: 21..23,
          moderately_high: 24..25,
          high: 27..29,
          very_high: 31..33
        ]
      },
      %{
        age_range: 36..45,
        classifications: [
          excellent: 16..19,
          good: 20..23,
          adequate: 24..26,
          moderately_high: 27..29,
          high: 30..32,
          very_high: 33..36
        ]
      },
      %{
        age_range: 46..55,
        classifications: [
          excellent: 17..21,
          good: 23..25,
          adequate: 26..28,
          moderately_high: 29..31,
          high: 32..34,
          very_high: 35..38
        ]
      },
      %{
        age_range: 56..65,
        classifications: [
          excellent: 18..22,
          good: 24..26,
          adequate: 27..29,
          moderately_high: 30..32,
          high: 33..35,
          very_high: 36..38
        ]
      }
    ]
  }

  @doc """
  Classifies body fat percentage based on gender and age.

  ## Parameters:
    - gender: :male or :female
    - age: age in years
    - fat_percentage: body fat percentage

  ## Returns:
    - A string indicating the classification (e.g., "excellent", "good", etc.)
    - "Invalid data or age out of considered ranges" if parameters do not match any range

  ## Examples:

      iex> BodyComposition.classify_fat_percentage(:male, 30, 12)
      "good"

      iex> BodyComposition.classify_fat_percentage(:female, 40, 25)
      "moderately_high"

  """
  def classify(gender, age, fat_percentage) do
    gender
    |> Map.get(@classification_tables, [])
    |> Enum.find(fn table -> age in table.age_range end)
    |> case do
      nil ->
        "Invalid data or age out of considered ranges"

        table -> 
          Enum.find_value(table.classifications, "Out of standards", &classify_value/1)
      end
    end

    defp classify_value({classification, range}) do
      if fat_percentage in range, do: Atom.to_string(classification)
    end
  end
end
