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

  alias Stash.Books
  alias Stash.Projections.{Book, UserBook}
  alias Stash.Queries.ById
  alias Stash.Core.Utils

  project(%BookCreated{book_id: id, isbn: isbn} = event, fn multi ->
    user_book_struct = %UserBook{
      id: id,
      user_id: event.user_id,
      list_id: event.list_id,
      tags: event.tags,
      notes: event.notes,
      title: event.title,
      isbn: event.isbn,
      thumbnail: event.thumbnail
    }

    case Books.book_by_isbn(isbn) do
      {:ok, _book} ->
        Ecto.Multi.insert(multi, :user_book, user_book_struct)

      {:error, _} ->
        book_struct = %Book{
          id: Utils.new_id(),
          title: event.title,
          isbn: event.isbn,
          thumbnail: event.thumbnail
        }

        multi
        |> Ecto.Multi.insert(:book, book_struct)
        |> Ecto.Multi.insert(:user_book, user_book_struct)
    end
  end)

  project(%BookTagsChanged{book_id: id, tags: tags}, fn multi ->
    update_book(multi, id, tags: tags)
  end)

  project(%BookNotesChanged{book_id: id, notes: notes}, fn multi ->
    update_book(multi, id, notes: notes)
  end)

  project(%BookDeleted{book_id: id}, fn multi ->
    Ecto.Multi.delete_all(multi, :book, ById.one(UserBook, id))
  end)

  defp update_book(multi, id, changes) do
    Ecto.Multi.update_all(multi, :book, ById.one(UserBook, id), set: changes)
  end
end
