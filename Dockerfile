FROM elixir:1.10

WORKDIR /home/elixir/app

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.exs ./mix.exs
COPY lib ./lib
COPY config ./config

RUN mix deps.get
RUN mix compile

EXPOSE 4000

# To build and run a single container
# docker build . -t elixir_rest:elixir_rest && docker run -p 4000:4000 elixir_rest
# Uncomment if you're not running docker with docker-compose
# ENTRYPOINT [ "mix", "run", "--no-halt" ]
