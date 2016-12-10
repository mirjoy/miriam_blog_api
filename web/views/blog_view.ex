defmodule MiriamBlogApi.BlogView do
  use MiriamBlogApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :post, :inserted_at, :updated_at]


end
