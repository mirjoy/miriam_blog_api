defmodule MiriamBlogApi.Factory do
  use ExMachina.Ecto, repo: MiriamBlogApi.Repo

  def blog_factory do
    %MiriamBlogApi.Blog{
      title: Faker.Company.name,
      post: Faker.Lorem.Shakespeare.En.hamlet,
      user: build(:user)
    }
  end

  def user_factory do
    %MiriamBlogApi.User{
      first_name: Faker.Name.first_name,
      last_name: Faker.Name.last_name,
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

end
