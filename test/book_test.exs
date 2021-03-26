defmodule Stash.BookTest do
  alias Stash.{Books, DataCase}
  alias Stash.Projections.UserBook, as: Book

  use DataCase

  @moduletag models: :book

  describe "a book" do
    test "can be created" do
      user = %{lists: [list]} = create_user_having_a_list("book")
      assert {:ok, %Book{id: book_id}} = create_book(user, list_id: list["id"])
      assert {:ok, %Book{}} = Books.book_by_id(book_id)
    end

    test "can be updated" do
      user = %{lists: [list]} = create_user_having_a_list("book")
      {:ok, %Book{} = book} = create_book(user, list_id: list["id"])
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
      user = %{lists: [list], id: user_id} = create_user_having_a_list("book")
      {:ok, %Book{} = book} = create_book(user, list_id: list["id"])
      assert :ok = Books.delete_book(book)
      assert {:error, :not_found} = Books.book_by_user_and_id(user_id, book.id)
    end
  end
end
