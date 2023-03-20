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

alias Blog.Posts
alias Blog.Repo
alias Blog.Posts.Post

# Delete existing posts
Repo.delete_all(Post)

Repo.insert(%Post{
  title: "My First Blog Post",
  content: "Welcome to my new blog! I'm excited to share my thoughts and ideas with you."
})

Repo.insert(%Post{
  title: "My Second Blog Post",
  content: "This blog should be a great time, maximum vibes.",
  published_on: Date.add(Date.utc_today(), -10)
})

Repo.insert(%Post{
  title: "My Third Blog Post",
  content: "This blog is going great amazing.",
  published_on: Date.add(Date.utc_today(), -10),
  visible: false
})

Repo.insert(%Post{
  title: "My Fourth Blog Post",
  content: "Please send help.",
  published_on: Date.add(Date.utc_today(), 10)
})
