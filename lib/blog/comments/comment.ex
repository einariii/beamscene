defmodule Blog.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  This file sets the comments schema.
  """
  schema "comments" do
    field :content, :string
    belongs_to :post, Blog.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :post_id])
    |> validate_required([:content])
    # |> Ecto.Changeset.put_assoc(:posts, comment)
  end
end
