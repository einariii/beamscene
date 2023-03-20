defmodule Blog.Posts.Post do
  @moduledoc """
  Documentation for Blog.Posts.Post
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :content, :string
    field :published_on, :date
    field :visible, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_on, :visible])
    |> validate_required([:title, :content, :visible])
  end
end
