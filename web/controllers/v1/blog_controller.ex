defmodule MiriamBlogApi.BlogController do
  use MiriamBlogApi.Web, :controller
  plug JaResource
  # plug MiriamBlogApi.Authenticate when action in [:create, :update, :delete]

end
