defmodule EvolutionWeb.Router do
  use EvolutionWeb, :router

  alias EvolutionWeb.Plugs.Auth

  pipeline :api do
    plug :accepts, ~w(json)
  end

  pipeline :auth do
    plug Auth
  end

  scope "/", EvolutionWeb do
    pipe_through :api
  end

  scope "/", EvolutionWeb.Controllers do
    resources "/auth", AuthController, only: [:create]
  end

  scope "/measurements", EvolutionWeb do
    pipe_through :api
    pipe_through :auth

    resources "/skin_folds", SkinFoldController, only: [:index, :create]
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:evolution, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: EvolutionWeb.Telemetry
    end
  end
end
