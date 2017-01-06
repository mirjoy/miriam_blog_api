defmodule MiriamBlogApi.Authenticate do
  use MiriamBlogApi.Web, :interactor
  alias MiriamBlogApi.{User,Token}
  alias Comeonin.Bcrypt

  def handle_call(%{email: email, password: password}) do
    case authenticate(email, password) do
      nil  -> nil
      user -> token_changeset(user)
    end
  end

  def handle_call(%{token: token}) do
    case verify_token(token) do
      nil       -> nil
      old_token ->
        Multi.new
        |> Multi.delete(:old, old_token)
        |> Multi.insert(:token, token_changeset(old_token.user))
    end
  end

  defp authenticate(email, password) do
    User
    |> Repo.get_by(email: String.downcase(email))
    |> check_password(password)
  end

  defp verify_token(token) do
    Token
    |> Token.where_unexpired
    |> Token.where_type("refresh")
    |> preload(:user)
    |> Repo.get_by(token: token)
  end

  defp check_password(nil, _password) do
    # Crypt nothing - prevent email enumeration
    Bcrypt.dummy_checkpw
    nil
  end

  defp check_password(user, password) do
    case Bcrypt.checkpw(password, user.hashed_password) do
      true -> user
      _    -> nil
    end
  end

  defp token_changeset(user) do
    attrs = %{
      type:       "refresh",
      user_id:    user.id,
      expires_at: expires_at,
    }
    %Token{user: user}
    |> change(attrs)
    |> Token.put_token
    |> Token.validations
  end

  defp expires_at do
    Timex.now
    |> Timex.shift(days: 60)
    |> Timex.to_erl
    |> Ecto.DateTime.cast
    |> elem(1)
  end
end
