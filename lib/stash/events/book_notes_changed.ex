defmodule Stash.Events.BookNotesChanged do
  @derive Jason.Encoder
  defstruct [:book_id, :list_id, :user_id, :notes]
end
