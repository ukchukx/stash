defmodule Stash.Projections.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [
    :id,
    :user_id,
    :title,
    :imdb_id,
    :tags,
    :thumbnail,
    :inserted_at,
    :updated_at
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "movies" do
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
