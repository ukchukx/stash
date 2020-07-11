defmodule Stash.Projections.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [
    :id,
    :title,
    :isbn,
    :notes,
    :tags,
    :thumbnail,
    :inserted_at,
    :updated_at
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "books" do
    field :user_id, :binary_id
    field :title, :string
    field :isbn, :string
    field :notes, :string
    field :thumbnail, :string
    field :tags, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  def changeset(params), do: changeset(%__MODULE__{}, params)

  def changeset(%__MODULE__{} = module, params), do: cast(module, params, @fields)
end
