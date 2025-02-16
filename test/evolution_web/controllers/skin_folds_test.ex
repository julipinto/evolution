defmodule EvolutionWeb.SkinFoldControllerTest do
  @moduledoc """
  Tests for the SkinFoldController.
  """
  use EvolutionWeb.ConnCase

  alias Evolution.Fixtures.SkinFoldsFixture
  alias Evolution.Fixtures.UserFixture

  @path "/measurements/skin_folds"

  setup %{conn: conn} do
    # Create a user with 25 years old to always match the calculation
    today = Date.utc_today()
    today_year = today.year
    birthdate = Date.new(today_year - 25, today.month, today.day) |> elem(1)
    user = UserFixture.create_user(%{birthdate: birthdate})
    conn = authenticate(conn, user)
    {:ok, conn: conn, user: user}
  end

  describe "should list Skin Folds" do
    test "get skin folds", %{conn: conn, user: user} do
      skin_fold = SkinFoldsFixture.create_skin_folds(user.id)
      skin_fold_id = skin_fold.id

      skin_folds = conn |> get(@path) |> json_response(200) |> Map.get("skin_folds")

      assert skin_folds == [
               %{
                 "id" => skin_fold_id,
                 "measurements" => %{
                   "abdominal" => 18.7,
                   "biceps" => 8.3,
                   "subscapular" => 14.2,
                   "suprailiac" => 10.5,
                   "thigh" => 16.1,
                   "triceps" => 12.4
                 },
                 "diffs" => %{
                   "abdominal" => -1.0,
                   "biceps" => 0.2,
                   "subscapular" => 0.4,
                   "suprailiac" => -0.7,
                   "thigh" => -0.3,
                   "triceps" => -0.5
                 },
                 "measured_at" => "2025-02-14",
                 "stats" => %{
                   "body_density" => 1.065,
                   "fat_classification" => "Athletic",
                   "fat_mass" => 12.0,
                   "fat_percentage" => 15.8,
                   "lean_mass" => 53.0,
                   "residual_mass" => 10.5,
                   "weight" => 75.5
                 }
               }
             ]
    end
  end

  describe "create Skin Fold" do
    test "should create skin fold with right params", %{conn: conn} do
      params = %{
        "triceps" => 17.6,
        "biceps" => 13.8,
        "abdominal" => 28.8,
        "subscapular" => 27,
        "thigh" => 31.5,
        "suprailiac" => 25.9,
        "weight" => 99.9,
        "measured_at" => "2021-01-01"
      }

      result = conn |> post(@path, params) |> json_response(201)

      assert result == %{
               "skin_fold" => %{
                 "diffs" => %{
                   "abdominal" => nil,
                   "biceps" => nil,
                   "subscapular" => nil,
                   "suprailiac" => nil,
                   "thigh" => nil,
                   "triceps" => nil
                 },
                 "id" => 1,
                 "measured_at" => "2021-01-01",
                 "measurements" => %{
                   "abdominal" => 28.8,
                   "biceps" => 13.8,
                   "subscapular" => 27.0,
                   "suprailiac" => 25.9,
                   "thigh" => 31.5,
                   "triceps" => 17.6
                 },
                 "stats" => %{
                   "body_density" => 1.0344821000000002,
                   "fat_classification" => "Out of standards",
                   "fat_mass" => 27.53938097703182,
                   "fat_percentage" => 27.566947924956775,
                   "lean_mass" => 72.3606190229682,
                   "residual_mass" => 20.8791,
                   "weight" => 99.9
                 }
               }
             }
    end

    test "should create skin fold with default measure_at today", %{conn: conn} do
      today = Date.utc_today() |> Date.to_string()

      params = %{
        "triceps" => 12.4,
        "biceps" => 8.3,
        "abdominal" => 18.7,
        "subscapular" => 14.2,
        "thigh" => 16.1,
        "suprailiac" => 10.5,
        "weight" => 70.0
      }

      result = conn |> post(@path, params) |> json_response(201)
      assert result["skin_fold"]["measured_at"] == today
    end

    # test "get skin folds", %{conn: conn, user: user} do
    #   skin_fold = insert(:skin_fold, user_id: user.id)
    #   conn = get(conn, skin_fold_path(conn, :index))
    #   assert json_response(conn, 200)["data"] == [%{id: skin_fold.id}]
    # end

    # test "get skin fold", %{conn: conn, user: user} do
    #   skin_fold = insert(:skin_fold, user_id: user.id)
    #   conn = get(conn, skin_fold_path(conn, :show, skin_fold.id))
    #   assert json_response(conn, 200)["data"]["id"] == skin_fold.id
    # end

    # test "update skin fold", %{conn: conn, user: user} do
    #   skin_fold = insert(:skin_fold, user_id: user.id)
    #   conn = put(conn, skin_fold_path(conn, :update, skin_fold.id), %{skin_fold: %{triceps: 20.0}})
    #   assert json_response(conn, 200)["data"]["triceps"] == 20.0
    # end

    # test "delete skin fold", %{conn: conn, user: user} do
    #   skin_fold = insert(:skin_fold, user_id: user.id)
    #   conn = delete(conn, skin_fold_path(conn, :delete, skin_fold.id))
    #   assert json_response(conn, 200)["data"]["id"] == skin_fold.id
    # end
  end
end
