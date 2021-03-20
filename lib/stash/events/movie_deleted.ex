defmodule Stash.Events.MovieDeleted do
  @derive Jason.Encoder
  defstruct [:movie_id, :list_id, :user_id]
end
