defmodule MiriamBlogApi.LoggedInController do
  use MiriamBlogApi.Web, :controller
  plug JaResource
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def login_page(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    # user may or may not be here.
  end

  # handle the case where no authenticated user
  # was found
  def unauthenticated(conn, params) do
    conn
    |> put_status(401)
  end
end
