defmodule Blog.Repo.Migrations.AddUserId do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    alter table(:comments) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
