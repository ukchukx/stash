defmodule Stash.Events.BookDeleted do
  @derive Jason.Encoder
  defstruct [:book_id]
end
