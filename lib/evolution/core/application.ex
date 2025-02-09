defmodule Evolution.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EvolutionWeb.Telemetry,
      Evolution.Repo,
      {DNSCluster, query: Application.get_env(:evolution, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Evolution.PubSub},
      # Start a worker by calling: Evolution.Worker.start_link(arg)
      # {Evolution.Worker, arg},
      # Start to serve requests, typically the last entry
      EvolutionWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Evolution.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EvolutionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
