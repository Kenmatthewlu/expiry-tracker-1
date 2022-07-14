defmodule EtWeb.Router do
  use EtWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EtWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :openapi do
    plug OpenApiSpex.Plug.PutApiSpec, module: EtWeb.ApiSpec
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EtWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through [:api]

    resources "/category", EtWeb.CategoryController,
      except: [:new, :edit],
      param: "category_id"

    resources "/perishable", EtWeb.PerishableController,
      except: [:new, :edit],
      param: "perishable_id"

    resources "/entry", EtWeb.EntryController,
      except: [:new, :edit],
      param: "entry_id"
  end

  scope "/api" do
    pipe_through [:api, :openapi]

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/" do
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end


  # Other scopes may use custom stacks.
  # scope "/api", EtWeb do
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

      live_dashboard "/dashboard", metrics: EtWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
