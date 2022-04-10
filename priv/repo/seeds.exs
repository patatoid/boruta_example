Boruta.Ecto.Admin.create_scope(
  %{
    name: "openid",
    public: true
  }
)
Boruta.Ecto.Admin.create_scope(
  %{
    name: "profile",
    public: true
  }
)
Boruta.Ecto.Admin.create_scope(
  %{
    name: "email",
    public: true
  }
)
Boruta.Ecto.Admin.create_scope(
  %{
    name: "address",
    public: true
  }
)
Boruta.Ecto.Admin.create_scope(
  %{
    name: "phone",
    public: true
  }
)

Boruta.Ecto.Admin.create_client(
  %{
    id: System.get_env("OAUTH_CLIENT_ID"),
    secret: System.get_env("OAUTH_CLIENT_SECRET"),
    redirect_uris: [
      "https://www.certification.openid.net/test/a/boruta_example/callback"
    ]
  }
)
