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
  def get_by(sub: sub) do
    with %User{id: id, email: email} = user <- Repo.get_by(User, id: sub) do
      {:ok, %ResourceOwner{sub: to_string(id), username: email}}
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
end
