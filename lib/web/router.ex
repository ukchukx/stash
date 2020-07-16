defmodule Stash.Web.Router do
  use Stash.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Stash.Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Stash.Web.Plugs.LoadCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Stash.Web do
    pipe_through :browser

    # live "/", PageLive, :index

    get "/", PageController, :index

    get "/signup", SessionController, :signup
    post "/signup", SessionController, :create_account
    get "/signin", SessionController, :signin
    post "/signin", SessionController, :create_session
    get "/signout", SessionController, :delete_session

    post "/movies", PageController, :create_movie
    post "/books", PageController, :create_book

    get "/*path", PageController, :catch_all
  end

  # Other scopes may use custom stacks.
  # scope "/api", Stash.Web do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: Stash.Web.Telemetry
    end
  end
end
