defmodule Blog.Repo.Migrations.AddUsernameToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
    end
  end
end
