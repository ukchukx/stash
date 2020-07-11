defmodule Stash.Repo do
  use Ecto.Repo,
    otp_app: :stash,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    {:ok, Confex.Resolver.resolve!(config)}
  end
end
