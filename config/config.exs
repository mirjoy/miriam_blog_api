# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ja_resource,
  repo: MiriamBlogApi.Repo

config :miriam_blog_api,
  ecto_repos: [MiriamBlogApi.Repo]

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Configures the endpoint
config :miriam_blog_api, MiriamBlogApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2xpGjBg6mWou3VsvrXzCXXFXhfHsne88gBC/VJ1qQa3GvgGKVygDGzVjlgZfYLLn",
  render_errors: [view: MiriamBlogApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MiriamBlogApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MiriamBlogApi",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "<guardian secret key>",
  serializer: MiriamBlogApi.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
