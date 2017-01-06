defmodule MiriamBlogApi.Repo.Migrations.CreateToken do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :type, :string
      add :token, :string
      add :expires_at, :datetime
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:tokens, [:user_id])

  end
end
