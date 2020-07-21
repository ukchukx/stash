defmodule Stash.Aggregates.Book do
  defstruct [:id, :isbn, :title, :notes, :thumbnail, :tags, :user_id, deleted: false]

  alias Stash.Commands.{
    DeleteBook,
    CreateBook,
    UpdateBook
  }

  alias Stash.Events.{
    BookDeleted,
    BookNotesChanged,
    BookTagsChanged,
    BookCreated
  }

  @behaviour Commanded.Aggregates.AggregateLifespan

  def execute(%__MODULE__{}, %CreateBook{} = command) do
    %BookCreated{
      user_id: command.user_id,
      book_id: command.book_id,
      isbn: command.isbn,
      title: command.title,
      notes: command.notes,
      tags: command.tags,
      thumbnail: command.thumbnail,
    }
  end

  def execute(%__MODULE__{id: id}, %DeleteBook{}), do: %BookDeleted{book_id: id}

  def execute(%__MODULE__{} = book, %UpdateBook{} = command) do
    [&notes_changed/2, &tags_changed/2]
    |> Enum.reduce([], fn (action, events) ->
      case action.(book, command) do
        nil   -> events
        event -> [event | events]
      end
    end)
  end

  def after_event(%BookDeleted{}), do: 5_000
  def after_event(_), do: :infinity

  def after_command(_command), do: :infinity
  def after_error(_error), do: :stop


  def apply(%__MODULE__{} = book, %BookCreated{} = e) do
    %__MODULE__{book |
      id: e.book_id,
      user_id: e.user_id,
      isbn: e.isbn,
      title: e.title,
      notes: e.notes,
      tags: e.tags,
      thumbnail: e.thumbnail,
    }
  end

  def apply(%__MODULE__{} = book, %BookTagsChanged{tags: tags}) do
    %__MODULE__{book | tags: tags}
  end

  def apply(%__MODULE__{} = book, %BookNotesChanged{notes: notes}) do
    %__MODULE__{book | notes: notes}
  end

  def apply(%__MODULE__{} = book, %BookDeleted{}) do
    %__MODULE__{book | deleted: true}
  end


  defp notes_changed(%__MODULE__{}, %UpdateBook{notes: n}) when n == "" or is_nil(n), do: nil
  defp notes_changed(%__MODULE__{notes: n}, %UpdateBook{notes: n}), do: nil
  defp notes_changed(%__MODULE__{id: id}, %UpdateBook{notes: notes}) do
    %BookNotesChanged{book_id: id, notes: notes}
  end

  defp tags_changed(%__MODULE__{}, %UpdateBook{tags: []}), do: nil
  defp tags_changed(%__MODULE__{tags: t}, %UpdateBook{tags: t}), do: nil
  defp tags_changed(%__MODULE__{id: id}, %UpdateBook{tags: tags}) do
    %BookTagsChanged{book_id: id, tags: tags}
  end
end
