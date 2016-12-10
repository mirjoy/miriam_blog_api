defmodule MiriamBlogApi.Blog do
  use MiriamBlogApi.Web, :model

  schema "blogs" do
    field :title, :string
    field :post, :string
    belongs_to :user, MiriamBlogApi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :post])
    |> validate_required([:title, :post])
  end
end
