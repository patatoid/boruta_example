defmodule BorutaExample.Repo.Migrations.AddDidToExampleClient do
  use Ecto.Migration

  def change do
    Application.ensure_all_started(:boruta)

    BorutaExample.Repo.get(Boruta.Ecto.Client, "00000000-0000-0000-0000-000000000001") |> Boruta.Ecto.Admin.regenerate_client_did()
  end
end
