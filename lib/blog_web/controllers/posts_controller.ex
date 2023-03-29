defmodule BlogWeb.PostsController do
  use BlogWeb, :controller

  alias Blog.Comments
  alias Blog.Comments.Comment
  alias Blog.Posts
  alias Blog.Posts.Post

  plug :require_user_owns_post when action in [:edit, :update, :delete]

  def require_user_owns_post(conn, _opts) do
    post_id = String.to_integer(conn.path_params["id"])
    post = Posts.get_post!(post_id)

    if conn.assigns[:current_user].id == post.user_id do
      conn
    else
      conn
      |> put_flash(:error, "You do not own this resource.")
      |> redirect(to: Routes.posts_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, %{"title" => title}) do
    posts = Posts.list_posts(title)
    render(conn, "index.html", posts: posts)
  end

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  # TODO consider adding user_id to post_params here instead of in the form

  def create(conn, %{"post" => post_params}) do
    user_id = conn.assigns[:current_user].id
    post_params = Map.put(post_params, "user_id", user_id)

    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.posts_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        # IO.inspect(changeset, label: "Changeset")
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id) |> Blog.Repo.preload([:comments])
    comment_changeset = Comments.change_comment(%Comment{})
    render(conn, "show.html", post: post, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.posts_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # IO.inspect("Post controller called")
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.posts_path(conn, :index))
  end
end
