defmodule Stash.Validators.ImdbId do
  alias Stash.Movies

  def validate(imdb_id) when is_binary(imdb_id), do: :ok

  def validate(_), do: {:error, "is not a string"}

  def imdb_id_taken?(imdb_id, user_id) do
    with {:ok, _} <- Movies.movie_by_user_and_imdb_id(user_id, imdb_id) do
      true
    else
      {:error, :not_found} -> false
    end
  end

end
