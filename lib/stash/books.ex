defmodule Stash.Books do
  alias Stash.Commands.{CreateBook, DeleteBook, UpdateBook}
  alias Stash.Queries.{ById, Books}
  alias Stash.{Commands, Queries}
  alias Stash.Projections.UserBook
  alias Stash.Core.Utils

  def build_create_book_command(%{} = attrs, %{user: %{id: id}} = _context) do
    attrs =
      attrs
      |> Map.put(:user_id, id)
      |> Map.put(:book_id, Utils.new_id())

    struct(CreateBook, attrs)
  end

  def build_update_book_command(%{id: id} = book, %{} = attrs) do
    attrs =
      attrs
      |> Map.put(:book_id, id)
      |> Map.put(:list_id, book.list_id)
      |> Map.put(:user_id, book.user_id)

    struct(UpdateBook, attrs)
  end

  def create_book(%{} = attrs, %{user: %{}} = context) do
    command = %{book_id: id} = build_create_book_command(attrs, context)

    command
    |> Commands.dispatch()
    |> case do
      {:ok, _state} -> book_by_id(id)
      response -> response
    end
  end

  def update_book(%{id: id, user_id: user_id} = _book, attrs = %{}) do
    with {:ok, %{list_id: list_id} = book} <- book_by_id(id),
         attrs =
           attrs
           |> Map.put(:list_id, list_id)
           |> Map.put(:user_id, user_id)
           |> Map.put(:book_id, id),
         {:ok, _state} <- book |> build_update_book_command(attrs) |> Commands.dispatch() do
      book_by_id(id)
    else
      reply -> reply
    end
  end

  def delete_book(%{id: id, user_id: user_id} = _book) do
    with {:ok, %{list_id: list_id}} <- book_by_id(id),
         attrs = %{book_id: id, user_id: user_id, list_id: list_id},
         {:ok, _state} <- DeleteBook |> struct(attrs) |> Commands.dispatch() do
      :ok
    else
      res -> res
    end
  end

  def book_by_id(id), do: UserBook |> ById.one(id) |> Queries.fetch_one()

  def book_by_isbn(isbn) do
    isbn
    |> Books.by_isbn()
    |> Queries.fetch_one()
  end

  def book_by_user_and_id(user_id, id) do
    user_id |> Books.by_user_and_id(id) |> Queries.fetch_one()
  end

  def book_by_user_and_isbn(user_id, isbn) do
    user_id |> Books.by_user_and_isbn(isbn) |> Queries.fetch_one()
  end

  def books_by_user_and_list(user_id, list_id) do
    user_id |> Books.by_user_and_list(list_id) |> Queries.fetch_all()
  end
end
