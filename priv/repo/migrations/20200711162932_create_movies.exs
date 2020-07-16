defmodule Stash.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid
      add :title, :string, size: 100
      add :thumbnail, :string
      add :imdb_id, :string, size: 20
      add :tags, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create index(:movies, [:user_id])
    create index(:movies, [:imdb_id])
  end
end
