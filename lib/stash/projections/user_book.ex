defmodule Stash.Projections.UserBook do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [
    :id,
    :list_id,
    :user_id,
    :notes,
    :title,
    :isbn,
    :tags,
    :thumbnail,
    :inserted_at,
    :updated_at
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "user_books" do
    field :list_id, :binary_id
    field :user_id, :binary_id
    field :notes, :string
    field :title, :string
    field :isbn, :string
    field :thumbnail, :string
    field :tags, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  def changeset(params), do: changeset(%__MODULE__{}, params)

  def changeset(%__MODULE__{} = module, params), do: cast(module, params, @fields)
end
