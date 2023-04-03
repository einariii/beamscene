alias Blog.Accounts
alias Blog.Accounts.User
alias Blog.Comments.Comment
alias Blog.Repo
alias Blog.Posts

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

  {:ok, user3} =
    case Repo.get_by(User, email: "account@account.com") do
      %User{} = user ->
        IO.inspect(user.email, label: "User Already Created")
        {:ok, user}

      nil ->
        user_attrs = %{email: "account@account.com", password: "password123!"}
        Accounts.register_user(user_attrs)
    end

# Blog posts without any comment
Enum.each(1..10, fn _ ->
  user_id = Enum.random([user1.id, user2.id, user3.id])
  title = Faker.Lorem.sentence(10)
  content = Faker.Lorem.paragraph(50)
  date = Faker.Date.backward(90)
  Posts.create_post(%{user_id: user_id, title: title, content: content, published_on: date})
end)


# Blog posts with only one associated comment
Enum.each(1..10, fn _ ->
  user_id = Enum.random([user1.id, user2.id, user3.id])
  title = Faker.Lorem.sentence(10)
  content =Faker.Lorem.paragraph(50)
  date = Faker.Date.backward(90)
  {:ok, post} = Posts.create_post(%{user_id: user_id, title: title, content: content, published_on: date})

  content = Faker.Lorem.paragraph(5)
  user_id = Enum.random([user1.id, user2.id, user3.id])
  %Comment{}
  |> Comment.changeset(%{user_id: user_id, content: content, post_id: post.id})
  |> Repo.insert!()
end)

# Blog posts with visibility set to false
Enum.each(1..10, fn _ ->
  user_id = Enum.random([user1.id, user2.id, user3.id])
  title = Faker.Lorem.sentence(10)
  content = Faker.Lorem.paragraph(50)
  date = Faker.Date.backward(90)
  Posts.create_post(%{user_id: user_id, title: title, content: content, published_on: date, visible: false})
end)

# Blog posts with future published on date
Enum.each(1..10, fn _ ->
  user_id = Enum.random([user1.id, user2.id, user3.id])
  title = Faker.Lorem.sentence(10)
  content = Faker.Lorem.paragraph(50)
  date = Faker.Date.forward(90)
  Posts.create_post(%{user_id: user_id, title: title, content: content, published_on: date})
end)

# Blog posts with both content and associated comments having a large amount of text

Enum.each(1..10, fn _ ->
  user_id = Enum.random([user1.id, user2.id, user3.id])
  title = Faker.Lorem.sentence(10)
  content =Faker.Lorem.paragraph(100)
  date = Faker.Date.backward(90)
  {:ok, post} = Posts.create_post(%{user_id: user_id, title: title, content: content, published_on: date})

  Enum.each(1..10, fn _ ->
    user_id = Enum.random([user1.id, user2.id, user3.id])
    content = Faker.Lorem.paragraph(25)
    %Comment{}
    |> Comment.changeset(%{user_id: user_id, content: content, post_id: post.id})
    |> Repo.insert!()
  end)
end)


# Blog posts with a large number of comments
Enum.each(1..5, fn _ ->
  user_id = Enum.random([user1.id, user2.id, user3.id])
  title = Faker.Lorem.sentence(10)
  content =Faker.Lorem.paragraph(100)
  date = Faker.Date.backward(90)
  {:ok, post} = Posts.create_post(%{user_id: user_id, title: title, content: content, published_on: date})

  Enum.each(1..50, fn _ ->
    user_id = Enum.random([user1.id, user2.id, user3.id])
    content = Faker.Lorem.paragraph(25)
    %Comment{}
    |> Comment.changeset(%{user_id: user_id, content: content, post_id: post.id})
    |> Repo.insert!()
  end)
end)
