defmodule Stash.Events.MovieCreated do
  @derive Jason.Encoder
  defstruct [:user_id, :list_id, :movie_id, :imdb_id, :title, :tags, :thumbnail]
end
