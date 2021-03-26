defmodule Stash.Projections.UserMovie do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [
    :id,
    :list_id,
    :user_id,
    :title,
    :imdb_id,
    :thumbnail,
    :tags,
    :inserted_at,
    :updated_at
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "user_movies" do
    field :list_id, :binary_id
    field :user_id, :binary_id
    field :title, :string
    field :imdb_id, :string
    field :thumbnail, :string
    field :tags, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  def changeset(params), do: changeset(%__MODULE__{}, params)

  def changeset(%__MODULE__{} = module, params), do: cast(module, params, @fields)
end
