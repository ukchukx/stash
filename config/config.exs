# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stash, :router,
  timeout: 10_000

config :stash,
  ecto_repos: [Stash.Repo],
  event_stores: [Stash.EventStore]

config :commanded_ecto_projections, repo: Stash.Repo

config :commanded, event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :stash, Stash.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Stash.EventStore
  ],
  pub_sub: :local,
  registry: :local

# Configures the endpoint
config :stash, Stash.Web.Endpoint,
  url: [host: {:system, "STASH_DNS_ADDR"}],
  secret_key_base: {:system, "STASH_SECRET_KEY_BASE"},
  render_errors: [view: Stash.Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Stash.PubSub,
  live_view: [signing_salt: "Oky+4yOc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  utc_log: true,
  truncate: :infinity

pool_size = "STASH_DB_POOL_SIZE" |> System.get_env |> String.to_integer

config :stash, Stash.Repo,
  truncate_read_tables_query: """
    TRUNCATE TABLE
      users,
      books,
      projection_versions
    RESTART IDENTITY;
    """,
  migration_timestamps: [type: :utc_datetime_usec],
  username: {:system, "STASH_DB_USER"},
  password: {:system, "STASH_DB_PASS"},
  database: {:system, "STASH_READ_DB"},
  hostname: {:system, "STASH_DB_HOST"},
  pool_size: pool_size,
  charset: "utf8mb4",
  collation: "utf8mb4_unicode_ci"

config :stash, Stash.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: {:system, "STASH_DB_USER"},
  password: {:system, "STASH_DB_PASS"},
  database: {:system, "STASH_EVENT_DB"},
  hostname: {:system, "STASH_DB_HOST"},
  pool_size: pool_size,
  charset: "utf8mb4",
  collation: "utf8mb4_unicode_ci"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
