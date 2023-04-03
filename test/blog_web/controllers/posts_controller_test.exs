defmodule BlogWeb.PostsControllerTest do
  use BlogWeb.ConnCase

  import Blog.PostsFixtures
  import Blog.AccountsFixtures

  @create_attrs %{content: "some content", subtitle: "some subtitle", title: "some title"}
  @update_attrs %{
    content: "some updated content",
    subtitle: "some updated subtitle",
    title: "some updated title"
  }
  @invalid_attrs %{content: nil, subtitle: nil, title: nil}
  setup [:register_and_log_in_user]

  describe "index" do
    test "lists all posts", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id, published_on: Date.utc_today())
      conn = get(conn, Routes.posts_path(conn, :index))
      assert html_response(conn, 200) =~ post.title
      assert html_response(conn, 200) =~ "Search Posts"
    end

    test "posts with a future published on date are not listed", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      post =
        post_fixture(
          user_id: user.id,
          title: "zbrBrfmrrxrrr! future me",
          published_on: Faker.Date.forward(90)
        )

      conn = get(conn, Routes.posts_path(conn, :index))
      assert html_response(conn, 200) =~ "Search Posts"
      refute html_response(conn, 200) =~ post.title
    end

    test "posts with visibility set to false are not listed", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      post =
        post_fixture(
          user_id: user.id,
          title: "zbrBrfmrrxrrr! invisible me",
          visible: false,
          published_on: Date.utc_today()
        )

      conn = get(conn, Routes.posts_path(conn, :index))
      assert html_response(conn, 200) =~ "Search Posts"
      refute html_response(conn, 200) =~ post.title
    end

    test "lists all posts _ matching search query", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      post =
        post_fixture(
          user_id: user.id,
          title: "Yo! The crazy blog",
          published_on: Date.utc_today()
        )

      conn = get(conn, Routes.posts_path(conn, :index, title: post.title))
      assert html_response(conn, 200) =~ post.title
    end

    test "lists all posts _ not matching search query", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id, title: "Generic Servers")
      conn = get(conn, Routes.posts_path(conn, :index, title: "The usual suspects"))
      refute html_response(conn, 200) =~ post.title
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.posts_path(conn, :new))
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()
      attributes = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, Routes.posts_path(conn, :create), post: attributes)
      assert get_flash(conn, :info) == "Post created successfully."

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.posts_path(conn, :show, id)

      conn = get(conn, Routes.posts_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.posts_path(conn, :create), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    # setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.posts_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    # setup [:create_post]

    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = log_in_user(conn, user)
      conn = put(conn, Routes.posts_path(conn, :update, post), post: @update_attrs)
      assert redirected_to(conn) == Routes.posts_path(conn, :show, post)

      conn = get(conn, Routes.posts_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = log_in_user(conn, user)
      conn = put(conn, Routes.posts_path(conn, :update, post), post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    test "deletes chosen post", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = log_in_user(conn, user)
      conn = delete(conn, Routes.posts_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.posts_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.posts_path(conn, :show, post))
      end
    end
  end
end
