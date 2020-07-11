defmodule Stash.BookTest do
  alias Stash.{Books, DataCase}
  alias Stash.Projections.Book

  use DataCase

  @moduletag models: :book
  @moduletag :book

  describe "a book" do
    test "can be created" do
      assert {:ok, %Book{id: book_id}} = fixture(:book)
      assert {:ok, _} = Books.book_by_id(book_id)
    end

    test "can be updated" do
      assert {:ok, %Book{id: book_id} = book} = fixture(:book)

      params = build_book_params() |> Map.take([:notes, :tags])

      assert {:ok, %Book{} = updated_book} = Books.update_book(book, params)

      # Unchanged
      assert book.id == updated_book.id
      assert book.title == updated_book.title
      assert book.isbn == updated_book.isbn
      assert book.thumbnail == updated_book.thumbnail
      # Changed
      assert updated_book.notes == params.notes
      assert updated_book.tags == params.tags
    end

    test "can be deleted" do
      assert {:ok, %Book{id: book_id} = book} = fixture(:book)
      assert :ok = Books.delete_book(book)
      assert {:error, :not_found} = Books.book_by_id(book_id)
    end
  end
end
