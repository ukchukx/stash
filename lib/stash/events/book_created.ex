defmodule Stash.Events.BookCreated do
  @derive Jason.Encoder
  defstruct [:user_id, :book_id, :isbn, :title, :tags, :notes, :thumbnail]
end
