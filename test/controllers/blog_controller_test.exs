defmodule MiriamBlogApi.BlogControllerTest do
  use MiriamBlogApi.ConnCase

  setup %{auth_conn: conn} do
    {:ok, conn: conn}
  end

  test "GET /v1/blogs", %{conn: conn} do
    Factory.insert_list(2, :blog)
    conn = get(conn, v1_blog_path(conn, :index))
    assert [_, _] = json_response(conn, 200)["data"]
  end

  test "GET /v1/blogs/:id", %{conn: conn} do
    b = Factory.insert(:blog)
    conn = get(conn, v1_blog_path(conn, :show, b.id))
    blog = json_response(conn, 200)
    assert blog["data"]["attributes"]["title"] == b.title
  end

  test "POST /v1/blogs - valid", %{conn: conn} do
    user = Factory.insert(:user)
    payload = %{
      data: %{
        type: "blog",
        attributes: %{
          title: "such title",
          post: "such content",
        },
        relationships: %{
          user: %{data: %{type: "user", id: "#{user.id}"}},
        }
      }
    }

    conn = post(conn, v1_blog_path(conn, :create), payload)
    resp = json_response(conn, 201)["data"]
    blog = Repo.get(Blog, resp["id"])
    assert blog.title == "such title"
    assert blog.post == "such content"
    assert blog.user_id == user.id
  end

  test "POST /v1/blogs - invalid", %{conn: conn} do
    payload = %{
      data: %{
        type: "blog",
        attributes: %{
          title: "such title",
          post: "such content",
        },
        relationships: %{
          user: %{data: %{type: "user", id: nil}},
        }
      }
    }

    conn = post(conn, v1_blog_path(conn, :create), payload)
    assert [_error] = json_response(conn, 422)["errors"]
  end

  test "PUT /v1/blogs/:id - valid", %{conn: conn} do
    blog = Factory.insert(:blog)
    payload = %{
      data: %{
        id:   "#{blog.id}",
        type: "blog",
        attributes: %{
          title:  "updated title",
        },
      }
    }

    conn = put(conn, v1_blog_path(conn, :update, blog.id), payload)
    resp = json_response(conn, 200)["data"]
    blog = Repo.get(Blog, resp["id"])
    assert blog.title == "updated title"
  end

  test "PUT /v1/blogs/:id - invalid", %{conn: conn} do
    blog = Factory.insert(:blog)
    payload = %{
      data: %{
        id:   "#{blog.id}",
        type: "blog",
        attributes: %{
          title: nil,
        },
      }
    }

    conn = put(conn, v1_blog_path(conn, :update, blog.id), payload)
    assert [_error] = json_response(conn, 422)["errors"]
  end

  test "DELETE /v1/blogs/:id", %{conn: conn} do
    blog = Factory.insert(:blog)
    conn = delete(conn, v1_blog_path(conn, :delete, blog.id))
    assert conn.status == 204
    refute Repo.get(Blog, blog.id)
  end
end
