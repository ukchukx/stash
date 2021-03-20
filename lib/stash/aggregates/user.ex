defmodule Stash.Aggregates.User do
  defstruct [:id, :record]

  alias Stash.Commands.{
    CreateBook,
    CreateList,
    CreateMovie,
    CreateUser,
    DeleteBook,
    DeleteList,
    DeleteMovie,
    DisableUser,
    EnableUser,
    UpdateBook,
    UpdateList,
    UpdateMovie,
    UpdateUser
  }

  alias Stash.Core.{Book, List, Movie, User}

  alias Stash.Events.{
    BookCreated,
    BookDeleted,
    BookNotesChanged,
    BookTagsChanged,
    ListCreated,
    ListDeleted,
    ListNameChanged,
    MovieCreated,
    MovieDeleted,
    MovieTagsChanged,
    UserCreated,
    UserDisabled,
    UserEmailChanged,
    UserEnabled,
    UserPasswordChanged
  }

  @behaviour Commanded.Aggregates.AggregateLifespan

  # User

  def execute(%__MODULE__{}, command = %CreateUser{}) do
    %UserCreated{
      user_id: command.user_id,
      email: command.email,
      active: command.active,
      password: command.password
    }
  end

  def execute(%__MODULE__{record: %{active: false}}, %EnableUser{user_id: id}),
    do: %UserEnabled{user_id: id}

  def execute(%__MODULE__{record: %{active: true}}, %EnableUser{}), do: []

  def execute(%__MODULE__{record: %{active: true}}, %DisableUser{user_id: id}),
    do: %UserDisabled{user_id: id}

  def execute(%__MODULE__{record: %{active: false}}, %DisableUser{}), do: []

  def execute(mod = %__MODULE__{}, command = %UpdateUser{}) do
    [&email_changed/2, &password_changed/2]
    |> Enum.reduce([], fn action, events ->
      case action.(mod, command) do
        nil -> events
        event -> [event | events]
      end
    end)
  end

  # List

  def execute(%__MODULE__{}, command = %CreateList{}) do
    %ListCreated{
      user_id: command.user_id,
      list_id: command.list_id,
      name: command.name,
      type: command.type
    }
  end

  def execute(%__MODULE__{record: user}, %DeleteList{list_id: id}) do
    case User.retrieve_list(user, id) do
      %List{} -> %ListDeleted{list_id: id, user_id: user.id}
      nil -> []
    end
  end

  def execute(%__MODULE__{record: user}, command = %UpdateList{list_id: id}) do
    list = User.retrieve_list(user, id)

    [&name_changed/2]
    |> Enum.reduce([], fn action, events ->
      case action.(list, command) do
        nil -> events
        event -> [event | events]
      end
    end)
  end

  # Movie

  def execute(%__MODULE__{}, command = %CreateMovie{}) do
    %MovieCreated{
      user_id: command.user_id,
      movie_id: command.movie_id,
      list_id: command.list_id,
      imdb_id: command.imdb_id,
      title: command.title,
      tags: command.tags,
      thumbnail: command.thumbnail
    }
  end

  def execute(%__MODULE__{record: user}, command = %DeleteMovie{movie_id: id}) do
    case User.retrieve_item_in_list(user, command.list_id, id) do
      nil -> []
      _ -> %MovieDeleted{movie_id: id, list_id: command.list_id, user_id: user.id}
    end
  end

  def execute(%__MODULE__{record: user}, command = %UpdateMovie{movie_id: id}) do
    case User.retrieve_item_in_list(user, command.list_id, id) do
      nil ->
        []

      movie ->
        [&movie_tags_changed/2]
        |> Enum.reduce([], fn action, events ->
          case action.(movie, command) do
            nil -> events
            event -> [event | events]
          end
        end)
    end
  end

  # Book

  def execute(%__MODULE__{}, command = %CreateBook{}) do
    %BookCreated{
      user_id: command.user_id,
      book_id: command.book_id,
      list_id: command.list_id,
      isbn: command.isbn,
      title: command.title,
      notes: command.notes,
      tags: command.tags,
      thumbnail: command.thumbnail
    }
  end

  def execute(%__MODULE__{record: user}, command = %DeleteBook{book_id: id}) do
    case User.retrieve_item_in_list(user, command.list_id, id) do
      nil -> []
      _ -> %BookDeleted{book_id: id, list_id: command.list_id, user_id: user.id}
    end
  end

  def execute(%__MODULE__{record: user}, %UpdateBook{book_id: id} = command) do
    case User.retrieve_item_in_list(user, command.list_id, id) do
      nil ->
        []

      book ->
        [&notes_changed/2, &book_tags_changed/2]
        |> Enum.reduce([], fn action, events ->
          case action.(book, command) do
            nil -> events
            event -> [event | events]
          end
        end)
    end
  end

  def after_event(%UserDisabled{}), do: :hibernate
  def after_event(_), do: :infinity

  def after_command(_command), do: :infinity
  def after_error(_error), do: :stop

  # User

  def apply(mod = %__MODULE__{}, e = %UserCreated{}) do
    user = User.new(e.email, active: e.active, password: e.password, id: e.user_id, lists: [])
    %__MODULE__{mod | id: user.id, record: user}
  end

  def apply(mod = %__MODULE__{record: user}, %UserEmailChanged{email: email}) do
    %__MODULE__{mod | record: User.change_email(user, email)}
  end

  def apply(mod = %__MODULE__{record: user}, %UserPasswordChanged{password: p}) do
    %__MODULE__{mod | record: User.change_password(user, p)}
  end

  def apply(mod = %__MODULE__{record: user}, %UserDisabled{}) do
    %__MODULE__{mod | record: User.disable(user)}
  end

  def apply(mod = %__MODULE__{record: user}, %UserEnabled{}) do
    %__MODULE__{mod | record: User.enable(user)}
  end

  # List

  def apply(mod = %__MODULE__{record: user}, e = %ListCreated{}) do
    list = List.new(e.name, e.type, id: e.list_id)
    %__MODULE__{mod | record: User.add_list(user, list)}
  end

  def apply(mod = %__MODULE__{record: user}, %ListNameChanged{name: n, list_id: id}) do
    list = User.retrieve_list(user, id)
    %__MODULE__{mod | record: User.replace_list(user, %{list | name: n})}
  end

  def apply(mod = %__MODULE__{record: user}, %ListDeleted{list_id: list_id}) do
    %__MODULE__{mod | record: User.remove_list(user, list_id)}
  end

  # Movie

  def apply(mod = %__MODULE__{record: user}, event = %MovieCreated{title: title}) do
    list = User.retrieve_list(user, event.list_id)

    movie =
      Movie.new(event.imdb_id, title,
        tags: event.tags,
        thumbnail: event.thumbnail,
        id: event.movie_id
      )

    list = List.add_item(list, movie)
    %__MODULE__{mod | record: User.replace_list(user, list)}
  end

  def apply(mod = %__MODULE__{record: user}, event = %MovieTagsChanged{tags: tags}) do
    list = User.retrieve_list(user, event.list_id)

    movie =
      user
      |> User.retrieve_item_in_list(event.list_id, event.movie_id)
      |> Map.put(:tags, tags)

    list = List.replace_item(list, movie)
    %__MODULE__{mod | record: User.replace_list(user, list)}
  end

  def apply(mod = %__MODULE__{record: user}, event = %MovieDeleted{movie_id: id}) do
    list =
      user
      |> User.retrieve_list(event.list_id)
      |> List.remove_item(id)

    %__MODULE__{mod | record: User.replace_list(user, list)}
  end

  # Book

  def apply(mod = %__MODULE__{record: user}, event = %BookCreated{title: title}) do
    list = User.retrieve_list(user, event.list_id)

    book =
      Book.new(event.isbn, title,
        tags: event.tags,
        notes: event.notes,
        thumbnail: event.thumbnail,
        id: event.book_id
      )

    list = List.add_item(list, book)
    %__MODULE__{mod | record: User.replace_list(user, list)}
  end

  def apply(mod = %__MODULE__{record: user}, event = %BookTagsChanged{tags: tags}) do
    list = User.retrieve_list(user, event.list_id)

    book =
      user
      |> User.retrieve_item_in_list(event.list_id, event.book_id)
      |> Map.put(:tags, tags)

    list = List.replace_item(list, book)
    %__MODULE__{mod | record: User.replace_list(user, list)}
  end

  def apply(mod = %__MODULE__{record: user}, event = %BookNotesChanged{notes: notes}) do
    list = User.retrieve_list(user, event.list_id)

    book =
      user
      |> User.retrieve_item_in_list(event.list_id, event.book_id)
      |> Map.put(:notes, notes)

    list = List.replace_item(list, book)
    %__MODULE__{mod | record: User.replace_list(user, list)}
  end

  def apply(mod = %__MODULE__{record: user}, event = %BookDeleted{book_id: id}) do
    list =
      user
      |> User.retrieve_list(event.list_id)
      |> List.remove_item(id)

    %__MODULE__{mod | record: User.replace_list(user, list)}
  end

  # User helpers

  defp email_changed(%__MODULE__{}, %UpdateUser{email: e}) when e == "" or is_nil(e), do: nil
  defp email_changed(%__MODULE__{record: %{email: email}}, %UpdateUser{email: email}), do: nil

  defp email_changed(%__MODULE__{id: id}, %UpdateUser{email: email}) do
    %UserEmailChanged{user_id: id, email: email}
  end

  defp password_changed(%__MODULE__{}, %UpdateUser{password: h}) when h == "" or is_nil(h),
    do: nil

  defp password_changed(%__MODULE__{id: id}, %UpdateUser{password: p}) do
    %UserPasswordChanged{user_id: id, password: p}
  end

  # Movie helpers

  defp movie_tags_changed(%Movie{tags: x}, %UpdateMovie{tags: x}), do: nil

  defp movie_tags_changed(%Movie{id: id}, command = %UpdateMovie{tags: tags}) do
    %MovieTagsChanged{
      movie_id: id,
      tags: tags,
      list_id: command.list_id,
      user_id: command.user_id
    }
  end

  # Book helpers

  defp notes_changed(%Book{}, %UpdateBook{notes: n}) when n == "" or is_nil(n), do: nil
  defp notes_changed(%Book{notes: x}, %UpdateBook{notes: x}), do: nil

  defp notes_changed(%Book{id: id}, command = %UpdateBook{notes: notes}) do
    %BookNotesChanged{
      book_id: id,
      user_id: command.user_id,
      list_id: command.list_id,
      notes: notes
    }
  end

  defp book_tags_changed(%Book{}, %UpdateBook{tags: nil}), do: nil
  defp book_tags_changed(%Book{tags: x}, %UpdateBook{tags: x}), do: nil

  defp book_tags_changed(%Book{id: id}, command = %UpdateBook{tags: tags}) do
    %BookTagsChanged{
      book_id: id,
      user_id: command.user_id,
      list_id: command.list_id,
      tags: tags
    }
  end

  # List helpers

  defp name_changed(%List{}, %UpdateList{name: n}) when n == "" or is_nil(n), do: nil
  defp name_changed(%List{name: x}, %UpdateList{name: x}), do: nil

  defp name_changed(%List{id: id}, command = %UpdateList{name: name}) do
    %ListNameChanged{
      list_id: id,
      user_id: command.user_id,
      name: name
    }
  end
end
