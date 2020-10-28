defmodule Foosball.Repo do
  use Ecto.Repo,
    otp_app: :foosball,
    adapter: Ecto.Adapters.Postgres
end
