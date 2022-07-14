defmodule Et.Repo do
  use Ecto.Repo,
    otp_app: :et,
    adapter: Ecto.Adapters.Postgres
end
