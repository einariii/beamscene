defmodule Blog.Repo.Migrations.AddDateVis do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :subtitle
      add :published_on, :date
      add :visible, :boolean, default: true
    end
  end
end
