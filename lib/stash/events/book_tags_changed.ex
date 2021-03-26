defmodule Stash.Events.BookTagsChanged do
  @derive Jason.Encoder
  defstruct [:book_id, :list_id, :user_id, :tags]
end
