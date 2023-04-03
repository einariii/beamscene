defmodule BlogWeb.CommentController do
  use BlogWeb, :controller

  alias Blog.Comments
  alias Blog.Comments.Comment

  plug :require_user_owns_comment when action in [:edit, :update, :delete]

  def require_user_owns_comment(conn, _opts) do
    # IO.inspect("Being called")
    comment_id = String.to_integer(conn.path_params["id"])
    comment = Comments.get_comment!(comment_id)

    if conn.assigns[:current_user].id == comment.user_id do
      # IO.inspect("Being called 2")
      conn
    else
      # IO.inspect("Being called 3")

      conn
      |> put_flash(:error, "You do not own this resource.")
      |> redirect(to: Routes.posts_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.html", comments: comments)
  end

  def new(conn, _params) do
    changeset = Comments.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"comment" => comment_params}) do
    # line 25: how to write redirect(to: Routes.posts_path(conn, :show, post))???
    user_id = conn.assigns[:current_user].id
    comment_params = Map.put(comment_params, "user_id", user_id)

    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.posts_path(conn, :show, comment.post_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        post = Blog.Posts.get_post!(comment_params["post_id"])

        conn
        |> put_view(BlogWeb.PostsView)
        |> render("show.html", comment_changeset: changeset, post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    changeset = Comments.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    case Comments.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.comment_path(conn, :show, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id} = params) do
    # IO.inspect(params, label: "Params")

    comment = Comments.get_comment!(id)
    # |> IO.inspect(label: "The COmment")

    {:ok, _comment} = Comments.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.posts_path(conn, :show, comment.post_id))
  end
end
