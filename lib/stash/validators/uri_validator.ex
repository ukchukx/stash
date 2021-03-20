defmodule Stash.Validators.URIValidator do
  def validate(value) do
    case URI.parse(value) do
      %{authority: a, scheme: s} when is_binary(a) and is_binary(s) -> :ok
      _ -> {:error, "is not a valid URI"}
    end
  end
end
