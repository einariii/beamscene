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

# Delete existing posts
Repo.delete_all(Post)

# Insert new posts
Repo.insert(%Post{
  title: "My First Blog Post",
  subtitle: "Introducing my new blog",
  content: "Welcome to my new blog! I'm excited to share my thoughts and ideas with you."
})

Repo.insert(%Post{
  title: "10 Tips for Writing Better Blog Posts",
  subtitle: "Improve your writing with these easy tips",
  content:
    "Writing great blog posts isn't easy, but with these tips you'll be well on your way to becoming a better writer."
})

Repo.insert(%Post{
  title: "Why I Quit My Job to Start a Blog",
  subtitle: "My journey to entrepreneurship",
  content:
    "After years of working for someone else, I decided to take the leap and start my own blog. Here's why I did it and what I've learned along the way."
})

Repo.insert(%Post{
  title: "The Benefits of Traveling Solo",
  subtitle: "Why you should try it at least once",
  content:
    "Traveling solo can be a transformative experience. In this post, I share some of the benefits I've discovered while exploring new places on my own."
})

Repo.insert(%Post{
  title: "How to Stay Productive While Working from Home",
  subtitle: "Tips for staying focused and getting things done",
  content:
    "Working from home has its perks, but it can also be challenging to stay productive. Here are some tips that have helped me stay focused and get things done."
})

Repo.insert(%Post{
  title: "My Favorite Books of 2022",
  subtitle: "A year-end reading roundup",
  content:
    "As another year comes to a close, I'm reflecting on the books that made an impact on me. Here are some of my favorites from the past year."
})

Repo.insert(%Post{
  title: "The Power of Positive Thinking",
  subtitle: "How changing your mindset can change your life",
  content:
    "Positive thinking can transform the way you approach challenges and opportunities. In this post, I explore the benefits of cultivating a more positive mindset."
})

Repo.insert(%Post{
  title: "The Importance of Self-Care for Entrepreneurs",
  subtitle: "Why taking care of yourself is crucial for success",
  content:
    "As an entrepreneur, it's easy to put your work ahead of your own well-being. But self-care is crucial for your success in the long run. Here's why."
})

Repo.insert(%Post{
  title: "Why Learning a New Language is Worth the Effort",
  subtitle: "The benefits of becoming multilingual",
  content:
    "Learning a new language can be a daunting task, but the benefits are numerous. From improving your cognitive function to expanding your cultural horizons, here's why it's worth the effort."
})

Repo.insert(%Post{
  title: "How to Overcome Writer's Block",
  subtitle: "Tips for getting unstuck and getting words on the page",
  content:
    "Writer's block can be frustrating and discouraging, but there are strategies you can use to overcome it. In this post, I share some tips for getting unstuck and getting words on the page."
})
