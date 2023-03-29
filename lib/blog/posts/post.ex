defmodule Blog.Posts.Post do
  @moduledoc """
  Documentation for Blog.Posts.Post
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    field(:content, :string)
    field(:published_on, :date)
    field(:visible, :boolean, default: true)
    has_many(:comments, Blog.Comments.Comment)
    belongs_to(:user, Blog.Users.User)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_on, :visible, :user_id])
    |> validate_required([:title, :content, :visible, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
