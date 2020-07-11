defmodule Stash.Events.BookNotesChanged do
  @derive Jason.Encoder
  defstruct [:book_id, :notes]
end
