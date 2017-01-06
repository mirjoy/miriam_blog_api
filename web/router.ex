defmodule MiriamBlogApi.Router do
  use MiriamBlogApi.Web, :router

  pipeline :std_json do
    plug :accepts, ["json"]
  end

  pipeline :json_public do
    plug :accepts, ["json-api"]
  end

  pipeline :json_api do
    plug :accepts, ["json-api"]

    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: TokenController
  end

  scope "/v1/auth", alias: MiriamBlogApi do
    pipe_through :std_json

    post "/token", TokenController, :create
  end

  scope "/", MiriamBlogApi do
    pipe_through :std_json

    get "/logged_in_page", LoggedInController, :logged_in_page
  end

  # public routes
  scope "/v1", as: :v1, alias: MiriamBlogApi do
    pipe_through :json_public

    resources "/blogs", BlogController, only: [:index, :show]
  end

  # private routes
  scope "/v1", as: :v1, alias: MiriamBlogApi do
    pipe_through :json_api

    resources "/blogs", BlogController, only: [:new, :edit, :create, :update, :delete]
  end

end
