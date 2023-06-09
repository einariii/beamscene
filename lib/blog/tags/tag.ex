defmodule Blog.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  This module contains functions for tag-related actions.
  """

  schema "tags" do
    field :name, :string
    many_to_many :posts, Blog.Tags.Tag, join_through: "post_tags", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
