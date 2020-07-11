defmodule Stash.Events.MovieDeleted do
  @derive Jason.Encoder
  defstruct [:movie_id]
end
