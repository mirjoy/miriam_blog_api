# Script for populating the database. You can run it as:
#     mix run priv/repo/seeds.exs

defmodule MiriamBlogApi.Seeds do
  use MiriamBlogApi.Web, :shared

  def create_blogs(blog_attrs) do
    %Blog{}
    |> Blog.changeset(blog_attrs)
    |> Repo.insert!
  end

  def blogposts do
    user = Repo.get_by(User, email: "mirjoy.moser@gmail.com")
    [
      %{title: Faker.Company.name, post: Faker.Lorem.Shakespeare.En.hamlet, user_id: user.id},
      %{title: Faker.Company.name, post: Faker.Lorem.Shakespeare.En.hamlet, user_id: user.id},
      %{title: Faker.Company.name, post: Faker.Lorem.Shakespeare.En.hamlet, user_id: user.id},
      %{title: Faker.Company.name, post: Faker.Lorem.Shakespeare.En.hamlet, user_id: user.id}
    ]
  end

  def create_seed_user do
    Repo.delete_all(User)

    %User{}
    |> User.changeset(%{first_name: "Miriam",
                        last_name: "Moser",
                        email: "mirjoy.moser@gmail.com",
                        is_admin: true})
    |> Repo.insert!
  end
end

MiriamBlogApi.Seeds.create_seed_user
Enum.each(MiriamBlogApi.Seeds.blogposts, &MiriamBlogApi.Seeds.create_blogs/1)
