# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :evolution,
  ecto_repos: [Evolution.Repo],
  generators: [timestamp_type: :utc_datetime]

config :evolution, Evolution.Repo, database: "priv/repo/db/evolution_#{Mix.env()}.db"

# Configures the endpoint
config :evolution, EvolutionWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: EvolutionWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Evolution.PubSub,
  live_view: [signing_salt: "9HxucEeY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  expose: ["Content-Disposition"],
  headers: ["Authorization", "Content-Type", "Accept"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
