defmodule BlogWeb.PostsView do
  use BlogWeb, :view

  def tag_options do
    Blog.Tags.list_tags() |> Enum.map(fn tag -> {tag.name, tag.id} end)
  end
end
