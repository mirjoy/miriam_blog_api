defmodule MiriamBlogApi.TokenTest do
  use MiriamBlogApi.ModelCase

  alias MiriamBlogApi.Token

  @valid_attrs %{expires_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, token: "some content", type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Token.changeset(%Token{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Token.changeset(%Token{}, @invalid_attrs)
    refute changeset.valid?
  end
end
