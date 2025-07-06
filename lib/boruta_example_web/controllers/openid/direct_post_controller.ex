defmodule BorutaExampleWeb.Openid.DirectPostController do
  @behaviour Boruta.Openid.DirectPostApplication

  use BorutaExampleWeb, :controller

  alias Boruta.Oauth.Error

  def direct_post(conn, %{"code_id" => code_id} = params) do
    direct_post_params = %{
      code_id: code_id
    }

    direct_post_params =
      case params do
        %{"id_token" => id_token} -> Map.put(direct_post_params, :id_token, id_token)
        %{"vp_token" => vp_token} -> Map.put(direct_post_params, :vp_token, vp_token)
        %{} -> direct_post_params
      end

    direct_post_params =
      case params do
        %{"presentation_submission" => presentation_submission} ->
          Map.put(direct_post_params, :presentation_submission, presentation_submission)

        %{} ->
          direct_post_params
      end

    Boruta.Openid.direct_post(conn, direct_post_params, __MODULE__)
  end

  @impl Boruta.Openid.DirectPostApplication
  def code_not_found(conn) do
    send_resp(conn, 404, "")
  end

  @impl Boruta.Openid.DirectPostApplication
  def authentication_failure(conn, %Error{
        redirect_uri: nil,
        status: status,
        error: error,
        error_description: error_description
      }) do
    conn
    |> put_status(status)
    |> put_view(OauthView)
    |> render("error.json", error: error, error_description: error_description)
  end

  def authentication_failure(conn, %Error{} = error) do
    redirect(conn, external: Error.redirect_to_url(error))
  end

  @impl Boruta.Openid.DirectPostApplication
  def direct_post_success(conn, response) do
    query =
      %{
        code: response.code.value,
        state: response.state
      }
      |> URI.encode_query()

    callback_uri = URI.parse(response.redirect_uri)

    callback_uri =
      %{callback_uri | host: callback_uri.host || "", query: query}
      |> URI.to_string()

    redirect(conn, external: callback_uri)
  end
end
