defmodule MiriamBlogApi.Repo.Migrations.CreateBlog do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :title, :string
      add :post, :string
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end
    create index(:blogs, [:user_id])

  end
end
