defmodule Stash.Books do
  alias Stash.Commands.{CreateBook, DeleteBook, UpdateBook}
  alias Stash.Queries.{ById, Books}
  alias Stash.{Commands, Queries}
  alias Stash.Projections.Book

  def build_create_book_command(%{} = attrs, %{user: %{id: id}} = _context) do
    attrs =
      attrs
      |> Map.put(:user_id, id)
      |> Map.put(:book_id, Ecto.UUID.generate())

    struct(CreateBook, attrs)
  end

  def build_update_book_command(%{id: id} = _book, %{} = attrs) do
    struct(UpdateBook, Map.put(attrs, :book_id, id))
  end

  def create_book(%{} = attrs, %{user: %{}} = context) do
    attrs
    |> build_create_book_command(context)
    |> Commands.dispatch
    |> case do
      {:ok, %{id: id}} -> book_by_id(id)
      response -> response
    end
  end

  def update_book(%{id: id} = _book, attrs = %{}) do
    with {:ok, %{} = book} <- book_by_id(id),
         {:ok, %{id: id}} <- book |> build_update_book_command(attrs) |> Commands.dispatch do
      book_by_id(id)
    else
      reply	-> reply
    end
  end

  def delete_book(%{id: id} = _book) do
    with {:ok, _} <- book_by_id(id),
         {:ok, _state}	<- DeleteBook |> struct(%{book_id: id}) |> Commands.dispatch do
      :ok
    else
      res -> res
    end
  end

  def book_by_id(id) when is_binary(id), do: Book |> ById.one(id) |> Queries.fetch_one

  def book_by_user_and_isbn(user_id, isbn) do
    user_id
    |> Books.by_user_and_isbn(isbn)
    |> Queries.fetch_one
  end

  def books_for_user(user_id), do: user_id |> Books.for_user |> Queries.fetch_all

end
