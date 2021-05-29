use Mix.Config

config :stash, :router, timeout: 10_000

config :stash,
  ecto_repos: [Stash.Repo],
  event_stores: [Stash.EventStore],
  tmdb_token: {:system, "TMDB_TOKEN"}

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
  http: [
    port: {:system, :integer, "STASH_HTTP_PORT"},
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: {:system, "STASH_DNS_ADDR"}, port: 80],
  live_view: [signing_salt: "Oky+4yOc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  utc_log: true,
  truncate: :infinity

config :stash, Stash.Repo,
  truncate_read_tables_query: """
  TRUNCATE TABLE
    users,
    books,
    movies,
    projection_versions
  RESTART IDENTITY;
  """,
  migration_timestamps: [type: :utc_datetime_usec],
  username: {:system, "STASH_DB_USER"},
  password: {:system, "STASH_DB_PASS"},
  database: {:system, "STASH_READ_DB"},
  hostname: {:system, "STASH_DB_HOST"},
  pool_size: {:system, :integer, "STASH_DB_POOL_SIZE"},
  charset: "utf8mb4",
  collation: "utf8mb4_unicode_ci"

config :stash, Stash.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: {:system, "STASH_DB_USER"},
  password: {:system, "STASH_DB_PASS"},
  database: {:system, "STASH_EVENT_DB"},
  hostname: {:system, "STASH_DB_HOST"},
  pool_size: {:system, :integer, "STASH_DB_POOL_SIZE"},
  charset: "utf8mb4",
  collation: "utf8mb4_unicode_ci"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
