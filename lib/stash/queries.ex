defmodule Stash.Queries do
  alias Stash.Repo

  import Ecto.Query

  def fetch_one(query) do
    query
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      row -> {:ok, row}
    end
  end

  def fetch_all(query), do: Repo.all(query)

  def count(query), do: from(q in query, select: fragment("count(*)"))

  def exists?(query), do: Repo.exists?(query)
end
