defmodule Stash.Events.MovieTagsChanged do
  @derive Jason.Encoder
  defstruct [:movie_id, :user_id, :list_id, :tags]
end
