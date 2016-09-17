defmodule MiriamBlogApi.BlogControllerTest do
  use MiriamBlogApi.ConnCase
  alias MiriamBlogApi.{Blog,Repo}

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, v1_blog_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    blog = Repo.insert! %Blog{}
    conn = get conn, v1_blog_path(conn, :show, blog)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{blog.id}"
    assert data["type"] == "blog"
    assert data["attributes"]["title"] == blog.title
    assert data["attributes"]["body"] == blog.body
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    conn = get conn, v1_blog_path(conn, :show, -1)
    assert json_response(conn, 404)["errors"]
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, v1_blog_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "blog",
        "attributes" => @valid_attrs,
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Blog, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, v1_blog_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "blog",
        "attributes" => @invalid_attrs,
      }
    }

    assert json_response(conn, 422)["errors"]
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    blog = Repo.insert! %Blog{}
    conn = put conn, v1_blog_path(conn, :update, blog), %{
      "meta" => %{},
      "data" => %{
        "type" => "blog",
        "id" => blog.id,
        "attributes" => @valid_attrs,
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Blog, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    blog = Repo.insert! %Blog{}
    conn = put conn, v1_blog_path(conn, :update, blog), %{
      "meta" => %{},
      "data" => %{
        "type" => "blog",
        "id" => blog.id,
        "attributes" => @invalid_attrs,
      }
    }

    assert json_response(conn, 422)["errors"]
  end

  test "deletes chosen resource", %{conn: conn} do
    blog = Repo.insert! %Blog{}
    conn = delete conn, v1_blog_path(conn, :delete, blog)
    assert response(conn, 204)
    refute Repo.get(Blog, blog.id)
  end

end
