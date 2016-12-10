defmodule MiriamBlogApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :is_admin, :boolean, default: false
      add :password, :string
      add :hashed_password, :string

      timestamps()
    end
    create unique_index(:users, [:email])

  end
end
