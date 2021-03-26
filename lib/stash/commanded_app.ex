defmodule Stash.CommandedApp do
  use Commanded.Application, otp_app: :stash

  router(Stash.Router)
end
