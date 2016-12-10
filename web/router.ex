defmodule MiriamBlogApi.Router do
  use MiriamBlogApi.Web, :router

  # "Regular" JSON, used by oauth, third party callbacks etc
  pipeline :std_json do
    plug :accepts, ["json"]
  end

  # JSON must conform to JSON-API spec
  pipeline :json_api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/api/v1", as: :v1, alias: MiriamBlogApi do
    pipe_through :json_api
    resources "/blogs", BlogController, except: [:new, :edit]
  end

end
