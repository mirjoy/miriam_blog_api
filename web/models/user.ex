defmodule MiriamBlogApi.User do
  use MiriamBlogApi.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :role, :string
    field :password, :string
    field :hashed_password, :string

    timestamps()
  end

  @castable [:first_name, :last_name, :email, :role, :password]
  @required [:first_name, :last_name, :email, :role]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @castable)
    |> validate_required(@required)
  end
end
