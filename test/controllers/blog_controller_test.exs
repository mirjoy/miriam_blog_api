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
end
