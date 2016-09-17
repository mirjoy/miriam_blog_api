defmodule MiriamBlogApi.BlogView do
  use MiriamBlogApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :body, :inserted_at, :updated_at]
  

end
