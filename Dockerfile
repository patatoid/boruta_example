FROM elixir:1.13.3 AS builder

ENV MIX_ENV=prod

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app
COPY . .
RUN mix do clean, deps.get
RUN mix compile

WORKDIR /app
RUN mix phx.digest
RUN mix release --force --overwrite

FROM elixir:1.13.3

RUN apt-get install -y libcurl4-openssl-dev libssl-dev libevent-dev

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/boruta_example ./

EXPOSE 4000
CMD ["/bin/sh", "-c", "/app/bin/boruta_example start"]
