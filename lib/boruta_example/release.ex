defmodule BorutaExample.Release do
  @moduledoc false
  @apps [:boruta_example]

  def migrate do
    for repo <- repos() do
      repo.__adapter__.storage_up(repo.config)

      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    repo.__adapter__.storage_up(repo.config)

    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    Code.eval_file(Path.join(:code.priv_dir(:boruta_example), "/repo/seeds.exs"))
  end

  def setup do
    migrate()
    seed()
  end

  defp repos do
    Enum.flat_map(@apps, fn app ->
      Application.ensure_all_started(app)
      Application.fetch_env!(app, :ecto_repos)
    end)
  end
end
