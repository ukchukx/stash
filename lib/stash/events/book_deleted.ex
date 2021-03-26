defmodule Stash.Events.BookDeleted do
  @derive Jason.Encoder
  defstruct [:book_id, :list_id, :user_id]
end
