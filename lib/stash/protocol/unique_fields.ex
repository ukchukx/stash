defprotocol Stash.Protocol.UniqueFields do
  @fallback_to_any true

  def unique(command)
end

defimpl Stash.Protocol.UniqueFields, for: Any do
  def unique(_command), do: :ok
end
