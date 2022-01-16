defmodule BorutaExample.Repo do
  use Ecto.Repo,
    otp_app: :boruta_example,
    adapter: Ecto.Adapters.Postgres
end
