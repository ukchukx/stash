defmodule Stash.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string, size: 150
      add :thumbnail, :string
      add :isbn, :string, size: 13

      timestamps(type: :utc_datetime)
    end

    create index(:books, [:isbn])
  end
end
