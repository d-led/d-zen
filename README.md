# Dzen

To start your Phoenix server:

* Install dependencies with `mix deps.get`
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Deployed

Deployed to [Gigalixir](https://gigalixir.com) &rarr; https://red-dark-honeyeater.gigalixirapp.com

## Log

* Latest Elixir & Erlang installed
* [Gigalixir Docs](https://gigalixir.readthedocs.io/en/latest/getting-started-guide.html)
* installed latest phoenix
  * `mix local.hex`
  * `mix archive.install hex phx_new`
* created the app `mix phx.new --no-ecto d-zen --app dzen`
* fetched the dependencies `mix deps.get`
* local live-reloadable start: `mix phx.server`
* registered & then logged into gigalixir: `gigalixir login`
* created the app: `APP_NAME=$(gigalixir create)`
  * if not automatically set, `gigalixir git:remote $APP_NAME`
* configured the versions
  * `echo "elixir_version=1.13.3" > elixir_buildpack.config`
  * `echo "erlang_version=23.3.2" >> elixir_buildpack.config`
  * `echo "node_version=14.15.4" > phoenix_static_buildpack.config`
* deploy to gigalixir: `git push gigalixir master`
* visit https://red-dark-honeyeater.gigalixirapp.com
  * wait for the load balancer start or restart the app in https://console.gigalixir.com

### Changes

- cleanup: c1c3ba41d99179a169868d4161a8067cd0d1656a
- begin with a live view: 0292d822379f6079fd2f07ed91e26a43cb55c5fc

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
