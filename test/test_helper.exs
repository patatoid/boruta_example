ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BorutaExample.Repo, :manual)

Mox.defmock(Boruta.OauthMock, for: Boruta.OauthModule)
Mox.defmock(Boruta.OpenidMock, for: Boruta.OpenidModule)
