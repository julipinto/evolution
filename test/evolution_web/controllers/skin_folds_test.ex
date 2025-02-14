defmodule EvolutionWeb.SkinFoldControllerTest do
  @moduledoc """
  Tests for the SkinFoldController.
  """
  use EvolutionWeb.ConnCase

  alias Evolution.Fixtures.SkinFoldsFixture
  alias Evolution.Fixtures.UserFixture
  # alias Evolution.Repositories.SkinFold
  # alias Evolution.Repositories.User

  @path "/measurements/skin_folds"

  setup %{conn: conn} do
    user = UserFixture.create_user()
    conn = authenticate(conn, user)
    {:ok, conn: conn, user: user}
  end

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
               }
             }
           ]
  end

  # test "create skin fold", %{conn: conn, user: user} do
  #   params = %{triceps: 10.0, subscapular: 10.0, suprailiac: 10.0, abdominal: 10.0, chest: 10.0, midaxillary: 10.0, thigh: 10.0, calf: 10.0}
  #   conn = post(conn, skin_fold_path(conn, :create), %{skin_fold: params})
  #   assert json_response(conn, 201)["data"]["id"]
  # end

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
