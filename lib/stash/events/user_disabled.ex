defmodule Stash.Events.UserDisabled do
  @derive Jason.Encoder
  defstruct [:user_id]
end
