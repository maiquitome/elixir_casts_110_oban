# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :teacher,
  ecto_repos: [Teacher.Repo]

# Configures the Oban
config :teacher, Oban,
  repo: Teacher.Repo,
  # O Pruner limpa os jobs que executaram com sucesso da tabela no PostgreSQL
  # pra tabela não ficar muito grande...
  #
  # :limit — the maximum number of jobs to prune at one time.
  # The default is 10,000 to prevent request timeouts.
  # Applications that steadily generate more than 10k jobs a minute should increase this value.
  plugins: [{Oban.Plugins.Pruner, limit: 11_000}],
  # em queues você consegue definir uma nova fila, exemplo: fila_teste
  # e definir a quantidade de jobs que vão executar de forma concorrente, exemplo: 10
  queues: [default: 10, events: 50, media: 20, fila_teste: 10]

# Configures the endpoint
config :teacher, TeacherWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TeacherWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Teacher.PubSub,
  live_view: [signing_salt: "4TOWRBkN"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :teacher, Teacher.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
