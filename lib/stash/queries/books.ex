defmodule Stash.Queries.Books do
  alias Stash.Projections.Book

  import Ecto.Query

  def by_user_and_isbn(user_id, isbn), do: from b in for_user(user_id), where: b.isbn == ^isbn

  def for_user(user_id), do: from b in Book, where: b.user_id == ^user_id

  def for_user(query, id), do: from q in query, where: q.user_id == ^id
end
