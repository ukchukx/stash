defmodule Stash.Events.BookTagsChanged do
  @derive Jason.Encoder
  defstruct [:book_id, :tags]
end
