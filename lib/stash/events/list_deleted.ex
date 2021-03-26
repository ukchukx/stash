defmodule Stash.Events.ListDeleted do
  @derive Jason.Encoder
  defstruct [:list_id, :user_id]
end
