# BorutaExample

Integration example of [boruta core library](https://hex.pm/packages/boruta) within a phoenix application.

## Setup

1. setup the application and the database

```
mix deps.get
mix ecto.migrate
cd ./assets/wallet
npm i
```

2. start the server

```
mix phx.server
```

## Links

1. Obtain an id_token

http://localhost:4000/oauth/authorize?client_id=00000000-0000-0000-0000-000000000001&redirect_uri=http://redirect.uri&response_type=id_token&state=qrm0c4xm&scope=openid&nonce=nonce

2. Obtain an access_token

http://localhost:4000/oauth/authorize?client_id=00000000-0000-0000-0000-000000000001&redirect_uri=http://redirect.uri&response_type=token&state=qrm0c4xm

1. Obtain an id_token and an access_token

http://localhost:4000/oauth/authorize?client_id=00000000-0000-0000-0000-000000000001&redirect_uri=http://redirect.uri&response_type=id_token+token&state=qrm0c4xm&scope=openid&nonce=nonce

3. Obtain an id_token and a code

http://localhost:4000/oauth/authorize?client_id=00000000-0000-0000-0000-000000000001&redirect_uri=http://redirect.uri&response_type=code+id_token&state=qrm0c4xm&scope=openid&nonce=nonce
