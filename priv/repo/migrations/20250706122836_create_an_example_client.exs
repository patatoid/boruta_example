defmodule BorutaExample.Repo.Migrations.CreateAnExampleClient do
  use Ecto.Migration

  def up do
    Boruta.Ecto.Admin.create_client(%{
      name: "Example client",
      id: "00000000-0000-0000-0000-000000000001",
      secret: "secret",
      redirect_uris: [
        "http://redirect.uri",
        "http://localhost:4000/wallet/preauthorized-code",
        "http://localhost:4000/wallet/verifiable-presentation"
      ]
    })
  end

  def down do
    BorutaExample.Repo.get!(Boruta.Ecto.Client, "00000000-0000-0000-0000-000000000001")
    |> BorutaExample.Repo.delete()
  end
end
