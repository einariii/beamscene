defmodule Blog.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blog.Posts` context.
  """
  # alias Blog.Repo
  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    # preload = Keyword.get(opts, :preload, false)

    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        subtitle: "some subtitle",
        title: "some title"
      })
      |> Blog.Posts.create_post()

    # if preload do
    #   ^post = Repo.preload(post, :comments)
    # end

    post
  end
end
