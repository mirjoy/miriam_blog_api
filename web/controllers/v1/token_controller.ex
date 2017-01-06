defmodule MiriamBlogApi.TokenController do
  use MiriamBlogApi.Web, :controller

  alias MiriamBlogApi.Authenticate

  # Password flow
  def create(conn, %{"grant_type" => "password", "username" => email, "password" => password}) do
    case Interactor.call(Authenticate, %{email: email, password: password}) do
      nil -> error(conn, "Email or password not found")
      {:ok, refresh_token} -> success(conn, refresh_token)
    end
  end

  # Refresh token flow
  def create(conn, %{"grant_type" => "refresh_token", "refresh_token" => t}) do
    case Interactor.call(Authenticate, %{token: t}) do
      nil -> error(conn, "Refresh token expired or invalid")
      {:ok, %{token: refresh_token}} -> success(conn, refresh_token)
    end
  end

  defp success(conn, refresh_token) do
    conn
    |> Guardian.Plug.api_sign_in(refresh_token.user) # TODO: Perms here
    |> put_status(201)
    |> render(:token, refresh_token: refresh_token)
  end

  defp error(conn, message) do
    conn
    |> put_status(422)
    |> render(:error, message: message)
  end
end
