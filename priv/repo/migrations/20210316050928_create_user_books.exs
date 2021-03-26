defmodule Stash.Repo.Migrations.CreateUserBooks do
  use Ecto.Migration

  def change do
    create table(:user_books, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid
      add :list_id, :uuid
      add :notes, :text
      add :title, :string, size: 150
      add :thumbnail, :string
      add :isbn, :string, size: 13
      add :tags, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create index(:user_books, [:user_id])
    create index(:user_books, [:list_id])
  end
end
