defmodule BorutaExample.Repo.Migrations.CreateExampleScope do
  use Ecto.Migration

  def change do
    Application.ensure_all_started(:boruta)

    Boruta.Ecto.Admin.create_scope(%{name: "email", public: true})
  end
end
