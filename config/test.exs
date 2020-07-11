use Mix.Config

config :bcrypt_elixir, :log_rounds, 4
# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stash, Stash.Repo,
  username: {:system, "STASH_DB_USER"},
  password: {:system, "STASH_DB_PASS"},
  database: {:system, "STASH_TEST_READ_DB"},
  hostname: {:system, "STASH_DB_HOST"},
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stash, Stash.Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
