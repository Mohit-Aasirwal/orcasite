use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# OrcasiteWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :orcasite, OrcasiteWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: System.get_env("HOST_URL"), port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :orcasite, Orcasite.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  types: Orcasite.PostgresTypes

# Do not print debug messages in production
config :logger, level: :info, format: {Orcasite.Logger, :format}

config :orcasite, :orcasite_s3_url, System.get_env("ORCASITE_S3_URL")

config :orcasite, OrcasiteWeb.Guardian,
  issuer: "orcasite",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Finally import the config/prod.secret.exs
# which should be versioned separately.
# import_config "prod.secret.exs"
