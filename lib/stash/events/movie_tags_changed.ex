defmodule Stash.Events.MovieTagsChanged do
  @derive Jason.Encoder
  defstruct [:movie_id, :tags]
end
