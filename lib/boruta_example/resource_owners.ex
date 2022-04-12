defmodule BorutaExample.ResourceOwners do
  @behaviour Boruta.Oauth.ResourceOwners

  alias Boruta.Oauth.ResourceOwner
  alias Boruta.Oauth.Scope
  alias BorutaExample.Accounts.User
  alias BorutaExample.Repo

  @impl Boruta.Oauth.ResourceOwners
  def get_by(username: username) do
    with %User{id: id, email: email, last_login_at: last_login_at} <- Repo.get_by(User, email: username) do
      {:ok, %ResourceOwner{sub: to_string(id), username: email, last_login_at: last_login_at}}
    else
      _ -> {:error, "User not found."}
    end
  end

  def get_by(sub: sub) do
    with %User{id: id, email: email, last_login_at: last_login_at} <- Repo.get_by(User, id: sub) do
      {:ok, %ResourceOwner{sub: to_string(id), username: email, last_login_at: last_login_at}}
    else
      _ -> {:error, "User not found."}
    end
  end

  @impl Boruta.Oauth.ResourceOwners
  def check_password(%ResourceOwner{sub: sub}, password) do
    user = Repo.get_by(User, id: sub)

    case User.valid_password?(user, password) do
      true -> :ok
      false -> {:error, "Invalid email or password."}
    end
  end

  @impl Boruta.Oauth.ResourceOwners
  def authorized_scopes(%ResourceOwner{}), do: []

  @impl Boruta.Oauth.ResourceOwners
  def claims(%ResourceOwner{sub: sub}, scope) do
    case Repo.get_by(User, id: sub) do
      %User{email: email} ->
        scope
        |> Scope.split()
        |> Enum.reduce(%{}, fn
          "email", acc ->
            Map.merge(acc, %{
              "email" => email,
              "email_verified" => false
            })

          "phone", acc ->
            Map.merge(acc, %{
              "phone_number_verified" => false,
              "phone_number" => "+33612345678"
            })

          "profile", acc ->
            Map.merge(acc, %{
              "profile" => "http://profile.host",
              "preferred_username" => "prefered_username",
              "updated_at" => :os.system_time(:seconds),
              "website" => "website",
              "zoneinfo" => "zoneinfo",
              "birthdate" => "2021-08-01",
              "gender" => "gender",
              "prefered_username" => "prefered_username",
              "given_name" => "given_name",
              "middle_name" => "middle_name",
              "locale" => "FR",
              "picture" => "picture",
              "updates_at" => "updates_at",
              "name" => "name",
              "nickname" => "nickname",
              "family_name" => "family_name"
            })

          "address", acc ->
            Map.put(acc, "address", %{
              "formatted" => "3 rue Dupont-Moriety, 75021 Paris, France",
              "street_address" => "3 rue Dupont-Moriety",
              "locality" => "Paris",
              "region" => "Ile-de-France",
              "postal_code" => "75021",
              "country" => "France"
            })

          _, acc ->
            acc
        end)

      _ ->
        %{}
    end
  end
end
