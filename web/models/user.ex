defmodule MiriamBlogApi.User do
  use MiriamBlogApi.Web, :model
  alias Comeonin.Bcrypt

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :is_admin, :boolean, default: false
    field :password, :string, virtual: true
    field :hashed_password, :string

    has_many :tokens, MiriamBlogApi.Token

    timestamps()
  end

  @castable [:first_name, :last_name, :email, :is_admin, :password]
  @required [:first_name, :last_name, :email, :is_admin]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @castable)
    |> validate_required(@required)
    |> downcase_email
    |> hash_password
  end

  # Only downcased if present
  defp downcase_email(changeset) do
    case get_field(changeset, :email) do
      nil   -> changeset
      email -> put_change(changeset, :email, String.downcase(email))
    end
  end

  # Only hashed if present
  def hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      pw ->  put_change(changeset, :hashed_password, Bcrypt.hashpwsalt(pw))
    end
  end
end
