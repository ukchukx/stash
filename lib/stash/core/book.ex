defmodule Stash.Core.Book do
  @moduledoc false

  alias Stash.Core.Utils

  defstruct [:id, :isbn, :title, :notes, :tags, :thumbnail]

  def new(isbn, title, opts \\ []) do
    attrs = %{
      isbn: isbn,
      title: title,
      thumbnail: Keyword.get(opts, :thumbnail),
      notes: Keyword.get(opts, :notes),
      id: Keyword.get(opts, :id, Utils.new_id()),
      tags: Keyword.get(opts, :tags, [])
    }

    struct!(__MODULE__, attrs)
  end
end
