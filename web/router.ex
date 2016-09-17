defmodule MiriamBlogApi.Router do
  use MiriamBlogApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api/v1", as: :v1, alias: MiriamBlogApi do
    pipe_through :api
    resources "/blogs", BlogController, except: [:new, :edit]
  end

end
