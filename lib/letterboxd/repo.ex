defmodule Letterboxd.Repo do
  use Ecto.Repo,
    otp_app: :letterboxd,
    adapter: Ecto.Adapters.Postgres
end
