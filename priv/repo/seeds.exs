# Script for populating the database. You can run it as:
#     mix run priv/repo/seeds.exs

alias MiriamBlogApi.{Blog,Repo}

defmodule MiriamBlogApi.Seeds do
  def create_blogs(blog_attrs) do
    %Blog{}
    |> Blog.changeset(blog_attrs)
    |> Repo.insert!
  end

  def blogposts do
    [
      %{title: Faker.Company.name, body: Faker.Lorem.Shakespeare.En.hamlet},
      %{title: Faker.Company.name, body: Faker.Lorem.Shakespeare.En.hamlet},
      %{title: Faker.Company.name, body: Faker.Lorem.Shakespeare.En.hamlet},
      %{title: Faker.Company.name, body: Faker.Lorem.Shakespeare.En.hamlet}
    ]
  end
end

Enum.each(MiriamBlogApi.Seeds.blogposts, &MiriamBlogApi.Seeds.create_blogs/1)
