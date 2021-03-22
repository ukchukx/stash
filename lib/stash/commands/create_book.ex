defmodule Stash.Commands.CreateBook do
  defstruct [:user_id, :list_id, :book_id, :isbn, :title, :thumbnail, notes: "", tags: []]

  def assign_id(%__MODULE__{} = command, id), do: %__MODULE__{command | book_id: id}
end

defimpl Stash.Protocol.UniqueFields, for: Stash.Commands.CreateBook do
  alias Stash.Validators.ISBN

  def unique(%{isbn: nil} = _command), do: {:error, [isbn: "is not provided"]}

  def unique(%{isbn: ""} = _command), do: {:error, [isbn: "is not provided"]}

  def unique(%{isbn: isbn, user_id: user_id} = _command) do
    validate_isbn(user_id, isbn)
    |> case do
      :ok -> :ok
      err -> {:error, Keyword.new([err])}
    end
  end

  defp validate_isbn(user_id, isbn) do
    case ISBN.isbn_taken?(user_id, isbn) do
      false -> :ok
      true -> {:isbn, "has been used"}
    end
  end
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.CreateBook do
  alias Stash.Validators.{ListValidator, StringValidator, Uuid, ISBN, URIValidator}

  def validate(%{user_id: user_id, book_id: book_id} = command) do
    user_id
    |> validate_user_id
    |> Kernel.++(validate_book_id(book_id))
    |> Kernel.++(validate_list_id(command.list_id))
    |> Kernel.++(validate_thumbnail(command.thumbnail))
    |> Kernel.++(validate_tags(command.tags))
    |> Kernel.++(validate_notes(command.notes))
    |> Kernel.++(validate_isbn(command.isbn))
    |> Kernel.++(validate_title(command.title))
    |> case do
      [] -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_user_id(user_id) do
    case Uuid.validate(user_id) do
      :ok -> []
      {:error, err} -> [{:user_id, err}]
    end
  end

  defp validate_list_id(list_id) do
    case Uuid.validate(list_id) do
      :ok -> []
      {:error, err} -> [{:list_id, err}]
    end
  end

  defp validate_book_id(book_id) do
    case Uuid.validate(book_id) do
      :ok -> []
      {:error, err} -> [{:book_id, err}]
    end
  end

  defp validate_tags([]), do: []

  defp validate_tags(nil), do: [{:tags, "is not a list"}]

  defp validate_tags(tags) do
    case ListValidator.validate_list_of_string(tags) do
      :ok -> []
      {:error, err} -> [{:tags, err}]
    end
  end

  defp validate_notes(""), do: []

  defp validate_notes(nil), do: [{:notes, "is not a string"}]

  defp validate_notes(notes) do
    case StringValidator.validate(notes) do
      :ok -> []
      {:error, err} -> [{:notes, err}]
    end
  end

  defp validate_title(""), do: [{:title, "is empty"}]

  defp validate_title(nil), do: [{:title, "is not a string"}]

  defp validate_title(title) do
    case StringValidator.validate(title) do
      :ok -> []
      {:error, err} -> [{:title, err}]
    end
  end

  defp validate_isbn(""), do: [{:isbn, "is empty"}]

  defp validate_isbn(nil), do: [{:isbn, "is not a string"}]

  defp validate_isbn(isbn) do
    case ISBN.validate(isbn) do
      :ok -> []
      {:error, err} -> [{:isbn, err}]
    end
  end

  defp validate_thumbnail(nil), do: []

  defp validate_thumbnail(thumbnail) do
    case URIValidator.validate(thumbnail) do
      :ok -> []
      {:error, err} -> [{:thumbnail, err}]
    end
  end
end
