defmodule Stash.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Stash.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Stash.Factory
      import Stash.Fixture
      import Stash.DataCase
      import Stash.Helpers.Wait
      import Stash.Helpers.ProcessHelper
    end
  end

  setup do
    Stash.Storage.reset!()
  end
end
