defmodule Evolution.Repo do
  use Ecto.Repo,
    otp_app: :evolution,
    adapter: Ecto.Adapters.SQLite3
end
