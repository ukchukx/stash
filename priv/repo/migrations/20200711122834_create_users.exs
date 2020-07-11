defmodule Stash.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :active, :boolean
      add :email, :string, size: 50
      add :password, :string, size: 100

      timestamps(type: :utc_datetime)
    end
    create index(:users, [:email])
  end
end
