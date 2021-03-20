defmodule Stash.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string, size: 100
      add :thumbnail, :string
      add :imdb_id, :string, size: 20

      timestamps(type: :utc_datetime)
    end

    create index(:movies, [:imdb_id])
  end
end
