defmodule Stash.Queries.Books do
  alias Stash.Projections.{Book, UserBook}

  import Ecto.Query

  def by_isbn(isbn), do: from(b in Book, where: b.isbn == ^isbn)

  def by_user_and_id(user_id, id),
    do: from(b in UserBook, where: b.id == ^id and b.user_id == ^user_id)

  def by_user_and_isbn(user_id, isbn),
    do: from(b in UserBook, where: b.isbn == ^isbn and b.user_id == ^user_id)

  def by_user_and_list(user_id, list_id),
    do: from(b in UserBook, where: b.list_id == ^list_id and b.user_id == ^user_id)
end
