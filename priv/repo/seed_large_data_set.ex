alias Blog.Posts
alias Blog.Comments.Comment
alias Blog.Repo

# Blog posts without any comment
Enum.each(1..10, fn _ ->
  title = Faker.Lorem.sentence(10)
  content = Faker.Lorem.paragraph(50)
  date = Faker.Date.backward(90)
  Posts.create_post(%{title: title, content: content, published_on: date})
end)


# Blog posts with only one associated comment
Enum.each(1..10, fn _ ->
  title = Faker.Lorem.sentence(10)
  content =Faker.Lorem.paragraph(50)
  date = Faker.Date.backward(90)
  {:ok, post} = Posts.create_post(%{title: title, content: content, published_on: date})

  %Comment{}
  |> Comment.changeset(%{content: Faker.Lorem.paragraph(5), post_id: post.id})
  |> Repo.insert!()
end)

# Blog posts with visibility set to false
Enum.each(1..10, fn _ ->
  title = Faker.Lorem.sentence(10)
  content = Faker.Lorem.paragraph(50)
  date = Faker.Date.backward(90)
  Posts.create_post(%{title: title, content: content, published_on: date, visible: false})
end)

# Blog posts with future published on date
Enum.each(1..10, fn _ ->
  title = Faker.Lorem.sentence(10)
  content = Faker.Lorem.paragraph(50)
  date = Faker.Date.forward(90)
  Posts.create_post(%{title: title, content: content, published_on: date})
end)

# Blog posts with both content and associated comments having a large amount of text

Enum.each(1..10, fn _ ->
  title = Faker.Lorem.sentence(10)
  content =Faker.Lorem.paragraph(100)
  date = Faker.Date.backward(90)
  {:ok, post} = Posts.create_post(%{title: title, content: content, published_on: date})

  Enum.each(1..10, fn _ ->
    %Comment{}
    |> Comment.changeset(%{content: Faker.Lorem.paragraph(25), post_id: post.id})
    |> Repo.insert!()
  end)
end)


# Blog posts with a large number of comments
Enum.each(1..5, fn _ ->
  title = Faker.Lorem.sentence(10)
  content =Faker.Lorem.paragraph(100)
  date = Faker.Date.backward(90)
  {:ok, post} = Posts.create_post(%{title: title, content: content, published_on: date})

  Enum.each(1..50, fn _ ->
    %Comment{}
    |> Comment.changeset(%{content: Faker.Lorem.paragraph(25), post_id: post.id})
    |> Repo.insert!()
  end)
end)
