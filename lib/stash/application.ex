defmodule Stash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:stash)

    children = [
      Stash.CommandedApp,
      # Start the Ecto repository
      Stash.Repo,
      Stash.CommandedSupervisor,
      # Start the Telemetry supervisor
      Stash.Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Stash.PubSub},
      # Start the Endpoint (http/https)
      Stash.Web.Endpoint
      # Start a worker by calling: Stash.Worker.start_link(arg)
      # {Stash.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Stash.Supervisor]
    case Supervisor.start_link(children, opts) do
      {:ok, _} = res ->
        Stash.TelemetryReporter.setup()
        res
      err_res -> err_res
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Stash.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
