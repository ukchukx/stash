use Mix.Config

config :stash, env: :test

config :bcrypt_elixir, :log_rounds, 4

config :commanded, assert_receive_event_timeout: 5_000

config :stash, Stash.EventStore,
  database: {:system, "STASH_TEST_EVENT_DB"},
  pool_size: 5

config :stash, Stash.Repo,
  database: {:system, "STASH_TEST_READ_DB"},
  pool_size: 5

config :stash, Stash.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.InMemory,
    serializer: Commanded.Serialization.JsonSerializer
  ]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stash, Stash.Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
