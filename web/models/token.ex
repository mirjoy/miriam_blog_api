defmodule MiriamBlogApi.Token do
  use MiriamBlogApi.Web, :model

  schema "tokens" do
    field :type, :string
    field :token, :string
    field :expires_at, Ecto.DateTime
    belongs_to :user, MiriamBlogApi.User

    timestamps()
  end

  def where_type(query, type), do: where(query, [t], t.type == ^type)

  def where_unexpired(query) do
    now = Ecto.DateTime.utc
    where(query, [t], t.expires_at > datetime_add(^now, -5, "minute"))
  end

  @types ["refresh", "password_reset"]
  def validations(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_inclusion(:type, @types)
    |> validate_required([:type, :token])
    |> assoc_constraint(:user)
    |> unique_constraint(:token)
  end

  def put_token(%Ecto.Changeset{} = changeset) do
    put_change(changeset, :token, gen_token)
  end

  defp gen_token do
    24
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
  end
end
