defprotocol Stash.Protocol.ValidCommand do
  @fallback_to_any true

  def validate(command)
end

defimpl Stash.Protocol.ValidCommand, for: Any do
  def validate(_command), do: :ok
end
