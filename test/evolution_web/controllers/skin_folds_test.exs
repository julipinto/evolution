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
    {:ok, birthdate} = Date.new(today_year - 25, today.month, today.day)
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
                 "measured_at" => "2025-02-14",
                 "measurements" => %{
                   "abdominal" => %{"current" => 18.7, "last_diff" => nil},
                   "biceps" => %{"current" => 8.3, "last_diff" => nil},
                   "subscapular" => %{"current" => 14.2, "last_diff" => nil},
                   "suprailiac" => %{"current" => 10.5, "last_diff" => nil},
                   "thigh" => %{"current" => 16.1, "last_diff" => nil},
                   "triceps" => %{"current" => 12.4, "last_diff" => nil},
                   "calf" => %{"current" => 6.0, "last_diff" => nil},
                   "middle_axillary" => %{"current" => 8.0, "last_diff" => nil}
                 },
                 "stats" => %{
                   "body_density" => %{"current" => 1.065, "last_diff" => nil},
                   "fat_classification" => "Athletic",
                   "fat_mass" => %{"current" => 12.0, "last_diff" => nil},
                   "fat_percentage" => %{"current" => 15.8, "last_diff" => nil},
                   "lean_mass" => %{"current" => 53.0, "last_diff" => nil},
                   "residual_mass" => %{"current" => 10.5, "last_diff" => nil},
                   "weight" => %{"current" => 75.5, "last_diff" => nil}
                 },
                 "measured_by" => "John Doe"
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
        "middle_axillary" => 10.5,
        "calf" => 10.5,
        "weight" => 99.9,
        "measured_at" => "2021-01-01",
        "measured_by" => "John Doe"
      }

      result = conn |> post(@path, params) |> json_response(201)

      assert result == %{
               "skin_fold" => %{
                 "id" => 1,
                 "measured_at" => "2021-01-01",
                 "measured_by" => "John Doe",
                 "measurements" => %{
                   "abdominal" => 28.8,
                   "biceps" => 13.8,
                   "subscapular" => 27.0,
                   "suprailiac" => 25.9,
                   "thigh" => 31.5,
                   "triceps" => 17.6,
                   "calf" => 10.5,
                   "middle_axillary" => 10.5,
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
      today = Date.to_string(Date.utc_today())

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

    # test "should calculate diffs correctly", %{conn: conn} do
    #   first_measurement = %{
    #     "triceps" => 12.4,
    #     "biceps" => 8.3,
    #     # "abdominal" => 18.7, # missing measurement
    #     "subscapular" => 14.2,
    #     "thigh" => 16.1,
    #     "suprailiac" => 10.5,
    #     "weight" => 70.0
    #   }

    #   post(conn, @path, first_measurement)

    #   second_measurement = %{
    #     "triceps" => 12,
    #     "biceps" => 8.5,
    #     "abdominal" => 19.7,
    #     "subscapular" => nil,
    #     "thigh" => 16.4,
    #     "suprailiac" => 10.8,
    #     "weight" => 70.5
    #   }

    #   response = post(conn, @path, second_measurement)
    #   result = json_response(response, 201)

    #   assert result["skin_fold"]["diffs"] == %{
    #            "abdominal" => nil,
    #            "biceps" => -0.1999999999999993,
    #            "subscapular" => nil,
    #            "suprailiac" => -0.3000000000000007,
    #            "thigh" => -0.29999999999999716,
    #            "triceps" => 0.40000000000000036
    #          }
    # end

    test "should not calculate when invalid measurements are sent", %{conn: conn} do
      first_measurement = %{
        # "triceps" => 12.4, # missing required measurement
        "biceps" => 8.3,
        "abdominal" => 18.7,
        "subscapular" => 14.2,
        "thigh" => 16.1,
        "suprailiac" => 10.5,
        "weight" => 70.0
      }

      result = json_response(post(conn, @path, first_measurement), 400)

      assert result == %{"errors" => %{"detail" => "Bad Request"}}
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
