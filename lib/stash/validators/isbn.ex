defmodule Stash.Validators.ISBN do
  alias Stash.Books

  def validate(isbn) when is_binary(isbn) do
    length = String.length(isbn)

    case length == 10 or length == 13  do
      false -> {:error, "is not an ISBN"}
      true  -> :ok
    end
  end

  def validate(_), do: {:error, "is not a string"}

  def isbn_taken?(isbn, user_id) do
    with {:ok, _} <- Books.book_by_user_and_isbn(user_id, isbn) do
      true
    else
      {:error, :not_found} -> false
    end
  end

end
