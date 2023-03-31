defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts
  alias Blog.Repo

  describe "posts" do
    alias Blog.Posts.Post

    import Blog.PostsFixtures
    import Blog.AccountsFixtures

    @invalid_attrs %{content: nil, title: nil}

    test "list_posts/0 returns all posts" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert Posts.list_posts() == [post]
    end

    test "list_posts/1 _ matching title" do
      user = user_fixture()
      post = post_fixture(user_id: user.id, title: "Erlang Processes")
      assert Posts.list_posts("Erlang Processes") == [post]
    end

    test "list_posts/1 _ non matching title" do
      user = user_fixture()
      _post = post_fixture(user_id: user.id, title: "Queue Data Structure")
      assert Posts.list_posts("The Enum module") == []
    end

    test "list_posts/1 _ partially matching title" do
      user = user_fixture()
      post = post_fixture(user_id: user.id, title: "Who supervises the supervisor?")
      assert Posts.list_posts("Who") == [post]
      assert Posts.list_posts("supervises") == [post]
      assert Posts.list_posts("supervisor?") == [post]
    end

    test "list_posts/1 _ case insensitive match" do
      user = user_fixture()
      post = post_fixture(user_id: user.id, title: "Let it crash!")
      assert Posts.list_posts("LET") == [post]
      assert Posts.list_posts("let") == [post]
      assert Posts.list_posts("iT") == [post]
      assert Posts.list_posts("CraSh") == [post]
    end

    test "get_post!/1 returns the post with given id" do
      user = user_fixture()
      # Should this be preloaded (current both not)?
      post = post_fixture(user_id: user.id) |> Repo.preload([:comments])
      # post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()

      valid_attrs = %{
        user_id: user.id,
        content: "some content",
        title: "some title",
        published_on: ~D[2022-02-02],
        visible: true
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.title == "some title"
      assert post.published_on == ~D[2022-02-02]
      assert post.visible == true
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      update_attrs = %{
        content: "some updated content",
        title: "some updated title",
        published_on: ~D[2023-03-03],
        visible: false
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
      assert post.published_on == ~D[2023-03-03]
      assert post.visible == false
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id) |> Repo.preload([:comments])
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
