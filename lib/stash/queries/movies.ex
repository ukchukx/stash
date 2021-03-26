defmodule Stash.Queries.Movies do
  alias Stash.Projections.{Movie, UserMovie}

  import Ecto.Query

  def by_imdb_id(imdb_id), do: from(m in Movie, where: m.imdb_id == ^imdb_id)

  def by_user_and_id(user_id, id),
    do: from(m in UserMovie, where: m.id == ^id and m.user_id == ^user_id)

  def by_user_and_list(user_id, list_id),
    do: from(m in UserMovie, where: m.list_id == ^list_id and m.user_id == ^user_id)
end
