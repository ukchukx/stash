defmodule Stash.Projectors.Book do
  use Commanded.Projections.Ecto,
    name: "Projector.Book",
    application: Stash.CommandedApp,
    consistency: :strong

  alias Stash.Events.{
    BookDeleted,
    BookNotesChanged,
    BookTagsChanged,
    BookCreated
  }
  alias Stash.Projections.Book
  alias Stash.Queries.ById
  alias Stash.Support.Utils

  project %BookCreated{book_id: id} = event, fn multi ->
    changes =
      event
      |> Utils.to_map
      |> Map.drop([:book_id])
      |> Map.put(:id, id)

    Ecto.Multi.insert(multi, :book, struct(Book, changes))
  end

  project %BookTagsChanged{book_id: id, tags: tags}, fn multi ->
    update_book(multi, id, tags: tags)
  end

  project %BookNotesChanged{book_id: id, notes: notes}, fn multi ->
    update_book(multi, id, notes: notes)
  end

  project %BookDeleted{book_id: id}, fn multi ->
    Ecto.Multi.delete_all(multi, :book, ById.one(Book, id))
  end

  defp update_book(multi, id, changes) do
    Ecto.Multi.update_all(multi, :book, ById.one(Book, id), set: changes)
  end
end
