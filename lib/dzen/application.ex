defmodule Dzen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DzenWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dzen.PubSub},
      # Start the Endpoint (http/https)
      Dzen.Repo,
      DzenWeb.Endpoint,
      DzenWeb.Counter
      # Start a worker by calling: Dzen.Worker.start_link(arg)
      # {Dzen.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dzen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DzenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
