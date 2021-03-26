defmodule Stash.Repo.Migrations.CreateUserMovies do
  use Ecto.Migration

  def change do
    create table(:user_movies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid
      add :list_id, :uuid
      add :title, :string, size: 100
      add :thumbnail, :string
      add :imdb_id, :string, size: 20
      add :tags, {:array, :string}, default: []

      timestamps(type: :utc_datetime)
    end

    create index(:user_movies, [:user_id])
    create index(:user_movies, [:list_id])
  end
end
