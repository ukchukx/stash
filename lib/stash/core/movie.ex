defmodule Stash.Core.Movie do
  @moduledoc false

  alias Stash.Core.Utils

  defstruct [:id, :imdb_id, :title, :tags, :thumbnail]

  def new(imdb_id, title, opts \\ []) do
    attrs = %{
      imdb_id: imdb_id,
      title: title,
      thumbnail: Keyword.get(opts, :thumbnail),
      id: Keyword.get(opts, :id, Utils.new_id()),
      tags: Keyword.get(opts, :tags, [])
    }

    struct!(__MODULE__, attrs)
  end
end
