defmodule Teacher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Teacher.Repo,
      # Start the Telemetry supervisor
      TeacherWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Teacher.PubSub},
      # Start the Endpoint (http/https)
      TeacherWeb.Endpoint,
      # Start a worker by calling: Teacher.Worker.start_link(arg)
      # {Teacher.Worker, arg}
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Teacher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Conditionally disable queues or plugins here.
  defp oban_config do
    Application.fetch_env!(:teacher, Oban)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TeacherWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
