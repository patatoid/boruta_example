# Boruta Example

You'll find here an example of implementation of a basic [Boruta OAuth and OpenID Connect provider](https://patatoid.gitlab.io/boruta_auth).

Step by step guide to described how this example has been setup can be found [here](https://patatoid.gitlab.io/boruta_auth/provider_integration.html).

## Starting the web server

You can start this example provider by running the following command
```sh
~> mix do deps.get, ecto.setup, phx.server
```

## OpenID Connect core 1.0 certification

This project is deployed following continuous integration to a private kubernetes cluster. The application is exposed under `oauth.example.boruta.patatoid.fr` domain, accessible [here](https://oauth.example.boruta.patatoid.fr/).

This is intended to follow OpenID Connect core specification. The server passes certification test suites (as of [commit](https://gitlab.com/patatoid/boruta_example/-/commit/0f19f7d1c5ea6549e56c0776772ddac28374c07a)):
- Basic OpenID Provider - https://www.certification.openid.net/plan-detail.html?plan=e9l28WdqKZhWs&public=true
- Implicit OpenID Provider - https://www.certification.openid.net/plan-detail.html?plan=7h3ieIQijnm2s&public=true
- Hybrid OpenID Provider - https://www.certification.openid.net/plan-detail.html?plan=7Ta9iyup747KZ&public=true

This implementation got certified for the basic, implicit, and hybrid OpenID Profiles as of May 7th, 2022.
