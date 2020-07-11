defmodule Stash.Events.MovieCreated do
  @derive Jason.Encoder
  defstruct [:user_id, :movie_id, :imdb_id, :title, :tags, :trailer, :thumbnail]
end
