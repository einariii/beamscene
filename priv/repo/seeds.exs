# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Blog.Accounts
alias Blog.Accounts.User
alias Blog.Comments.Comment
alias Blog.Posts
alias Blog.Posts.Post
alias Blog.Repo
alias Blog.Tags
alias Blog.Tags.Tag

## Seed Default Tags in database
tags = ["erlang", "elixir", "gleam", "luerl"]

Enum.each(tags, fn tag_name ->
  case Repo.get_by(Tag, name: tag_name) do
    %Tag{} = _tag ->
      IO.inspect(tag_name, label: "Tag Already Created")

    nil ->
      Tags.create_tag(%{name: tag_name})
  end
end)

## Create 2 default users
{:ok, user1} =
  case Repo.get_by(User, email: "test@test.com") do
    %User{} = user ->
      IO.inspect(user.email, label: "User Already Created")
      {:ok, user}

    nil ->
      user_attrs = %{email: "test@test.com", password: "password123!"}
      Accounts.register_user(user_attrs)
  end

{:ok, user2} =
  case Repo.get_by(User, email: "email@email.com") do
    %User{} = user ->
      IO.inspect(user.email, label: "User Already Created")
      {:ok, user}

    nil ->
      user_attrs = %{email: "email@email.com", password: "password123!"}
      Accounts.register_user(user_attrs)
  end

## A blog post without any comments
title = "I killed a process and that's ok"

case Repo.get_by(Post, title: title) do
  %Post{} = post ->
    IO.inspect(post.title, label: "Post Already Created")

  nil ->
    content = "You can kill my processes but I'll only get stronger. You heard me? Stronger!"
    date = Date.utc_today()
    Posts.create_post(%{user_id: user1.id, title: title, content: content, published_on: date})
end

## A blog post with an associated comment
title = "You wouldn't exist without Erlang"

{:ok, post} =
  case Repo.get_by(Post, title: title) do
    %Post{} = post ->
      IO.inspect(post.title, label: "Post Already Created")
      {:ok, post}

    nil ->
      content =
        "The Erlang programmer's girlfriend left him because she couldn't handle his high concurrency."

      date = Date.utc_today()
      Posts.create_post(%{user_id: user1.id, title: title, content: content, published_on: date})
  end

content = "She couldn't find her way out of all the recursion as well."

case Repo.get_by(Comment, content: content) do
  %Comment{} = comment ->
    IO.inspect(comment.content, label: "Comment Already Created")

  nil ->
    %Comment{}
    |> Comment.changeset(%{user_id: user2.id, content: content, post_id: post.id})
    |> Repo.insert!()
end

# A blog post with visibility set to false
title = "Fault-tolerance as first philosophy"

case Repo.get_by(Post, title: title) do
  %Post{} = post ->
    IO.inspect(post.title, label: "Post Already Created")

  nil ->
    content =
      "Why did the Erlang programmer refuse to get on the airplane? He didn't want to deal with all the crashing."

    date = Date.utc_today()

    Posts.create_post(%{
      user_id: user1.id,
      title: title,
      content: content,
      published_on: date,
      visible: false
    })
end

# A blog post with a future published on date
title = "Last night Elixir changed my life"

case Repo.get_by(Post, title: title) do
  %Post{} = post ->
    IO.inspect(post.title, label: "Post Already Created")

  nil ->
    content =
      "Last night Elixir changed my life. I finally learned how to spell \"parallelism\" correctly."

    date = Date.add(Date.utc_today(), 11)
    Posts.create_post(%{user_id: user1.id, title: title, content: content, published_on: date})
end

# A blog post with both content and associated comment having a large amount of text

title = "Typing head-first into the Gleamiverse"

{:ok, post} =
  case Repo.get_by(Post, title: title) do
    %Post{} = post ->
      IO.inspect(post.title, label: "Post Already Created")
      {:ok, post}

    nil ->
      date = Date.utc_today()

      Posts.create_post(%{
        user_id: user1.id,
        title: title,
        content: Faker.Lorem.paragraph(100),
        published_on: date
      })
  end

case Repo.get_by(Comment, post_id: post.id) do
  %Comment{} = comment ->
    IO.inspect(comment.content, label: "Comment Already Created")

  nil ->
    %Comment{}
    |> Comment.changeset(%{
      user_id: user2.id,
      content: Faker.Lorem.paragraph(50),
      post_id: post.id
    })
    |> Repo.insert!()
end
