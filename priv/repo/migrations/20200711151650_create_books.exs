defmodule Stash.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid
      add :title, :string, size: 100
      add :notes, :text
      add :thumbnail, :string
      add :isbn, :string, size: 13
      add :tags, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create index(:books, [:user_id])
    create index(:books, [:isbn])
  end
end
