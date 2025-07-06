defmodule BorutaExample.ResourceOwners do
  @behaviour Boruta.Oauth.ResourceOwners

  alias Boruta.Oauth.ResourceOwner
  alias BorutaExample.Accounts.User
  alias BorutaExample.Repo

  @impl Boruta.Oauth.ResourceOwners
  def get_by(username: username) do
    with %User{id: id, email: email} <- Repo.get_by(User, email: username) do
      {:ok, %ResourceOwner{sub: to_string(id), username: email}}
    else
      _ -> {:error, "User not found."}
    end
  end
  def get_by(sub: sub, scope: _scope) do
    with %User{id: id, email: email} = user <- Repo.get_by(User, id: sub) do
      {:ok, %ResourceOwner{
        sub: to_string(id),
        username: email,
        extra_claims: %{
          "username" => email
        },
        authorization_details: [%{
          "type" => "openid_credential",
          "format" => "jwt_vc",
          "credential_configuration_id" => "emailCredential",
          "credential_identifiers" => ["emailCredential"]
        }],
        credential_configuration: %{
          "emailCredential" => %{
            version: "13",
            vct: "urn:test",
            defered: false,
            types: ["emailCredential"],
            format: "jwt_vc",
            time_to_live: 3600 * 24 * 10,
            claims: [
              %{
                "name" => "username",
                "pointer" => "username"
              }
            ]
          }
        },
        presentation_configuration: %{
          "email" => %{
            definition: %{
              "id" => "email",
              "input_descriptors" => [%{
                "id" => "email",
                "format" => %{
                  "jwt_vc" => %{}
                },
                "constraints" => %{
                  "fields" => [%{"path" => ["$.username"]}]
                }
              }]
            }
          }
        }
      }}
    else
      _ -> {:error, "User not found."}
    end
  end

  @impl Boruta.Oauth.ResourceOwners
  def check_password(resource_owner, password) do
    user = Repo.get_by(User, id: resource_owner.sub)
    User.check_password(user, password)
  end

  @impl Boruta.Oauth.ResourceOwners
  def authorized_scopes(%ResourceOwner{}), do: []

  @impl Boruta.Oauth.ResourceOwners
  def claims(%ResourceOwner{username: username}, _scope), do: %{
    "username" => username
  }
end
