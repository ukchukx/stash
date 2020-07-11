defmodule Stash.Queries.Movies do
  alias Stash.Projections.Movie

  import Ecto.Query

  def by_user_and_imdb_id(user_id, imdb_id), do: from b in for_user(user_id), where: b.imdb_id == ^imdb_id

  def for_user(user_id), do: from m in Movie, where: m.user_id == ^user_id

  def for_user(query, id), do: from q in query, where: q.user_id == ^id
end
