defmodule MiriamBlogApi.LoginController do
  use MiriamBlogApi.Web, :controller
  plug JaResource
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def login_page(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    # user may or may not be here.
  end

   # handle the case where no authenticated user
   # was found
   def unauthenticated(conn, _params) do
     conn
     |> put_status(401)
     |> render(:error)
   end
end
