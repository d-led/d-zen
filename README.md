# Dzen

To start your Phoenix server:

* Install dependencies with `mix deps.get`
* Start Postgres, e.g. via `docker-compose up -d`
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
* added an [Ecto Repo](https://hexdocs.pm/ecto/getting-started.html#adding-ecto-to-an-application)
  * `mix ecto.create` after all the required code changes
  * `mix ecto.gen.migration create_counters` to initialize the counters
* created the free gigalixir DB tier: `gigalixir pg:create --free`

### Changes

- cleanup: [c1c3ba41d99179a169868d4161a8067cd0d1656a](https://github.com/d-led/d-zen/commit/c1c3ba41d99179a169868d4161a8067cd0d1656a)
- begin with a live view: [0292d822379f6079fd2f07ed91e26a43cb55c5fc](https://github.com/d-led/d-zen/commit/0292d822379f6079fd2f07ed91e26a43cb55c5fc)
- making websocket connections work on gigalixir: [66678ad5fc4f53e2e90bce790ecb1933f256b40d](https://github.com/d-led/d-zen/commit/66678ad5fc4f53e2e90bce790ecb1933f256b40d)
- [PubSub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html) & [LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) [b685c71233b9e200e9eb8a2dcb79b73e70c6b53e](https://github.com/d-led/d-zen/commit/b685c71233b9e200e9eb8a2dcb79b73e70c6b53e) + channel name fix [314b8191fb5e993038c3506bbbb89c87f9df1aa0](https://github.com/d-led/d-zen/commit/314b8191fb5e993038c3506bbbb89c87f9df1aa0)
- refactoring to not repeat the channel name mismatch mistake [ecd14f02bf71bb33c330b6abfe680580560e126f](https://github.com/d-led/d-zen/commit/ecd14f02bf71bb33c330b6abfe680580560e126f)
- added ecto to persist the counters: [diff before-ecto...master](https://github.com/d-led/d-zen/compare/before-ecto...master)

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

## Gigalixir Hands-On

### IEx in the Container

[docs](https://gigalixir.readthedocs.io/en/latest/runtime.html#how-to-ssh-into-a-production-container)

- `gigalixir account:ssh_keys:add "$(cat ~/.ssh/id_rsa.pub)"` and wait a couple of minutes
- `gigalixir ps:remote_console`

### Resetting the DB

[docs](https://gigalixir.readthedocs.io/en/latest/database.html#how-to-reset-the-database)

```elixir
# check the data
Dzen.Repo.all(Dzen.Counter)
# drop
Application.app_dir(:dzen, "priv/repo/migrations"), :down, [all: true])
# create
Ecto.Migrator.run(Dzen.Repo, Application.app_dir(:dzen, "priv/repo/migrations"), :up, [all: true])
```

### Changing an Entity

```elixir
# check the data
Dzen.Repo.all(Dzen.Counter)
# change the entity
Dzen.Repo.get_by(Dzen.Counter, id: 2)
|> Ecto.Changeset.change(%{value: 42})
|> Dzen.Repo.update()
```
