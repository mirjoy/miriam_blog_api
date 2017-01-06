defmodule MiriamBlogApi.TokenView do
  use MiriamBlogApi.Web, :view
  import Guardian.Plug, only: [current_token: 1, claims: 1]

  def render("token.json", %{conn: conn, refresh_token: refresh}) do
    %{
      access_token:  current_token(conn),
      refresh_token: refresh.token,
      token_type:    "bearer",
      expires_in:    elem(claims(conn), 1)["exp"],
    }
  end

  def render("error.json", %{message: message}) do
    %{
      error: message
    }
  end
end
