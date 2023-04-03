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

alias Blog.Repo
alias Blog.Posts.Post
alias Blog.Accounts
alias Blog.Tags
alias Blog.Tags.Tag

# Delete existing posts
Repo.delete_all(Post)
user_attrs = %{email: "test@test.com", password: "password123!"}
{:ok, user} = Accounts.register_user(user_attrs)

Repo.insert(%Post{
  user_id: user.id,
  published_on: Date.utc_today(),
  title: "My First Blog Post",
  content: "Welcome to my new blog! I'm excited to share my thoughts and ideas with you."
})

Repo.insert(%Post{
  user_id: user.id,
  title: "My Second Blog Post",
  content: "This blog should be a great time, maximum vibes.",
  published_on: Date.add(Date.utc_today(), -10)
})

Repo.insert(%Post{
  user_id: user.id,
  title: "My Third Blog Post",
  content: "This blog is going great amazing.",
  published_on: Date.add(Date.utc_today(), -10),
  visible: false
})

Repo.insert(%Post{
  user_id: user.id,
  title: "My Fourth Blog Post",
  content: "Please send help.",
  published_on: Date.add(Date.utc_today(), 10)
})

# Create tags
["erlang", "elixir", "gleam", "luerl"]
|> Enum.each(fn tag_name ->
  case Repo.get_by(Tag, name: tag_name) do
    %Tag{} = _tag ->
      IO.inspect(tag_name, label: "Tag Already Created")

    nil ->
      Tags.create_tag(%{name: tag_name})
  end
end)
