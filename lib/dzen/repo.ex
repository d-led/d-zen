defmodule Dzen.Repo do
  use Ecto.Repo,
    otp_app: :dzen,
    adapter: Ecto.Adapters.Postgres
end
