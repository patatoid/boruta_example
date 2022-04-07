defmodule BorutaExampleWeb.OpenidView do
  use BorutaExampleWeb, :view

  def render("jwks.json", %{jwk_keys: jwk_keys}) do
    %{keys: jwk_keys}
  end
end
