defmodule BlogWeb.CommentControllerTest do
  use BlogWeb.ConnCase

  import Blog.CommentsFixtures
  import Blog.PostsFixtures
  import Blog.AccountsFixtures
  alias Blog.Repo

  # @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  describe "index" do
    test "lists all comments", %{conn: conn} do
      conn = get(conn, Routes.comment_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Comments"
    end
  end

  # describe "new comment" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.comment_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Comment"
  #   end
  # end

  describe "create comment" do
    setup [:register_and_log_in_user]
    # test "fails without associated post", %{conn: conn} do
    #   conn = post(conn, Routes.comment_path(conn, :create), comment: @create_attrs)

    #   # assert %{id: id} = redirected_params(conn)
    #   # assert redirected_to(conn) == Routes.posts_path(conn, :show, id)
    #   assert html_response(conn, 200) =~ "Oops"

    #   # conn = get(conn, Routes.comment_path(conn, :show, id))
    #   # assert get_flash(conn, :info) == "Oops, something went wrong! Please check the errors below."
    # end

    test "create comment with associated post", %{conn: conn} do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id)
        |> Repo.preload([:comments])

      conn =
        post(conn, Routes.comment_path(conn, :create),
          comment: %{"user_id" => user.id, "post_id" => post.id, content: "A top comment"}
        )

      assert %{id: post_id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.posts_path(conn, :show, post_id)

      conn = get(conn, Routes.posts_path(conn, :show, post_id))
      # assert html_response(conn, 200) =~ "List Comments"
      assert html_response(conn, 200) =~ "A top comment"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      attrs = Map.put(@invalid_attrs, :post_id, post.id)
      # conn = post(conn, Routes.posts_path(conn, :create), comment: attrs)
      conn = post(conn, Routes.comment_path(conn, :create), comment: attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end

  describe "edit comment" do
    # setup [:create_comment]

    test "renders form for editing chosen comment", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      comment = comment_fixture(post_id: post.id, user_id: user.id)
      conn = log_in_user(conn, user)
      conn = get(conn, Routes.comment_path(conn, :edit, comment))
      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "update comment" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      post = post_fixture(user_id: user.id)
      comment = comment_fixture(user_id: user.id, post_id: post.id)

      conn = put(conn, Routes.comment_path(conn, :update, comment), comment: @update_attrs)
      conn = get(conn, Routes.comment_path(conn, :show, comment))

      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      comment = comment_fixture(user_id: user.id, post_id: post.id, content: "Secret comment bwa")
      conn = log_in_user(conn, user)
      conn = put(conn, Routes.comment_path(conn, :update, comment), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end
  end

  describe "delete comment" do
    test "deletes chosen comment", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      comment =
        comment_fixture(user_id: user.id, post_id: post.id, content: "Yet anther content!")

      conn = log_in_user(conn, user)
      conn = delete(conn, Routes.comment_path(conn, :delete, comment))

      conn = get(conn, Routes.posts_path(conn, :show, post))
      refute html_response(conn, 200) =~ comment.content
      # assert redirected_to(conn) == Routes.posts_path(conn, :show, post)

      # assert_error_sent 404, fn ->
      #   get(conn, Routes.comment_path(conn, :show, comment))
      # end
    end
  end
end
