defmodule MiriamBlogApi.Blog do
  use MiriamBlogApi.Web, :model

  schema "blogs" do
    field :title, :string
    field :post, :string
    belongs_to :user, User

    timestamps()
  end

  @castable [:title, :post, :user_id]
  @required [:title, :post, :user_id]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @castable)
    |> validate_required(@required)
    |> assoc_constraint(:user)
  end
end
