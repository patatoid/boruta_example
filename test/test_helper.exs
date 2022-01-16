ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BorutaExample.Repo, :manual)

Mox.defmock(Boruta.OauthMock, for: Boruta.OauthModule)
