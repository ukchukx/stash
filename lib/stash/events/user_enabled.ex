defmodule Stash.Events.UserEnabled do
  @derive Jason.Encoder
  defstruct [:user_id]
end
