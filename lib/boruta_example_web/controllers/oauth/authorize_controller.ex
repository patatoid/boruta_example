defmodule BorutaExampleWeb.Oauth.AuthorizeController do
  @behaviour Boruta.Oauth.AuthorizeApplication

  use BorutaExampleWeb, :controller

  alias Boruta.Oauth.AuthorizeResponse
  alias Boruta.Oauth.Error
  alias Boruta.Oauth.ResourceOwner
  alias Boruta.Openid.CredentialOfferResponse
  alias BorutaExampleWeb.OauthView

  def oauth_module, do: Application.get_env(:boruta_example, :oauth_module, Boruta.Oauth)

  def authorize(%Plug.Conn{} = conn, _params) do
    current_user = conn.assigns[:current_user]
    conn = store_user_return_to(conn)

    authorize_response(
      conn,
      current_user
    )
  end

  defp authorize_response(conn, %_{} = current_user) do
    conn
    |> oauth_module().authorize(
      %ResourceOwner{
        sub: to_string(current_user.id),
        username: current_user.email,
        extra_claims: %{
          "username" => current_user.email
        },
        authorization_details: [%{
          "type" => "openid_credential",
          "format" => "vc+sd-jwt",
          "credential_configuration_id" => "emailCredential",
          "credential_identifiers" => ["emailCredential"]
        }],
        credential_configuration: %{
          "emailCredential" => %{
            version: "13",
            vct: "urn:test",
            defered: false,
            types: ["emailCredential"],
            format: "vc+sd-jwt",
            time_to_live: 10,
            claims: [
              %{
                "name" => "username",
                "pointer" => "username"
              }
            ]
          }
        }
      },
      __MODULE__
    )
  end

  defp authorize_response(conn, _params) do
    redirect_to_login(conn)
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def authorize_success(
        conn,
        %AuthorizeResponse{} = response
      ) do
    redirect(conn, external: AuthorizeResponse.redirect_to_url(response))
  end

  def authorize_success(
        conn,
        %CredentialOfferResponse{} = response
      ) do

    redirect(conn, external: credential_offer_redirect_uri(response))
  end

  defp credential_offer_redirect_uri(credential_offer) do
    "#{credential_offer.redirect_uri}?credential_offer=#{credential_offer
      |> Map.from_struct()
      |> Map.take([:credential_configuration_ids, :credential_issuer, :grants])
      |> Jason.encode!()
      |> URI.encode_www_form()}"
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def authorize_error(
        %Plug.Conn{} = conn,
        %Error{status: :unauthorized, error: :invalid_resource_owner}
      ) do
    redirect_to_login(conn)
  end

  def authorize_error(
        conn,
        %Error{format: format} = error
      )
      when not is_nil(format) do
    conn
    |> redirect(external: Error.redirect_to_url(error))
  end

  def authorize_error(
        conn,
        %Error{status: status, error: error, error_description: error_description}
      ) do
    conn
    |> put_status(status)
    |> put_view(OauthView)
    |> render("error.html", error: error, error_description: error_description)
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_success(_conn, _response), do: :ok

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_error(_conn, _response), do: :ok

  defp store_user_return_to(conn) do
    conn
    |> put_session(
      :user_return_to,
      current_path(conn)
    )
  end

  defp redirect_to_login(conn) do
    redirect(conn, to: Routes.user_session_path(conn, :new))
  end
end
