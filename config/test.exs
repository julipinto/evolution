import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :evolution, Evolution.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "evolution_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :evolution, EvolutionWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "A+ylk+wbaBCqlgItv2/6+pxg/OystlqMIJSzp5hlIHKnux8a5R+J3kFcTqh5jofM",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :evolution, Evolution.Core.Guardian,
  issuer: "evolution",
  secret_key: "evolution_secret_key"
