defmodule Stash.Aggregates.Movie do
  defstruct [:id, :imdb_id, :title, :thumbnail, :tags, :user_id, deleted: false]

  alias Stash.Commands.{
    DeleteMovie,
    CreateMovie,
    UpdateMovie
  }

  alias Stash.Events.{
    MovieDeleted,
    MovieTagsChanged,
    MovieCreated
  }

  @behaviour Commanded.Aggregates.AggregateLifespan

  def execute(%__MODULE__{}, %CreateMovie{} = command) do
    %MovieCreated{
      user_id: command.user_id,
      movie_id: command.movie_id,
      imdb_id: command.imdb_id,
      title: command.title,
      tags: command.tags,
      thumbnail: command.thumbnail,
    }
  end

  def execute(%__MODULE__{id: id}, %DeleteMovie{}), do: %MovieDeleted{movie_id: id}

  def execute(%__MODULE__{} = movie, %UpdateMovie{} = command) do
    [&tags_changed/2]
    |> Enum.reduce([], fn (action, events) ->
      case action.(movie, command) do
        nil   -> events
        event -> [event | events]
      end
    end)
  end

  def after_event(%MovieDeleted{}), do: 5_000
  def after_event(_), do: :infinity

  def after_command(_command), do: :infinity
  def after_error(_error), do: :stop


  def apply(%__MODULE__{} = movie, %MovieCreated{} = e) do
    %__MODULE__{movie |
      id: e.movie_id,
      user_id: e.user_id,
      imdb_id: e.imdb_id,
      title: e.title,
      tags: e.tags,
      thumbnail: e.thumbnail,
    }
  end

  def apply(%__MODULE__{} = movie, %MovieTagsChanged{tags: tags}) do
    %__MODULE__{movie | tags: tags}
  end

  def apply(%__MODULE__{} = movie, %MovieDeleted{}) do
    %__MODULE__{movie | deleted: true}
  end


  defp tags_changed(%__MODULE__{}, %UpdateMovie{tags: []}), do: nil
  defp tags_changed(%__MODULE__{tags: t}, %UpdateMovie{tags: t}), do: nil
  defp tags_changed(%__MODULE__{id: id}, %UpdateMovie{tags: tags}) do
    %MovieTagsChanged{movie_id: id, tags: tags}
  end
end
