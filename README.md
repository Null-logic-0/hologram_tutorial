# Hologram Tutorial

A beginner's tutorial project for [Hologram](https://hologram.page) — nothing groundbreaking, just a typical todo list built with Hologram on top of Elixir and Phoenix.

The point isn't the app. The point is seeing how a Hologram page, component, action and command fit together in something small enough to read in one sitting.

## What's in it

A counter page and a todo list. You can add, complete and delete todos, and open one on its own page. Todos live in Postgres.

The list is **live**: open it in two tabs and a change in one shows up in the other immediately, no reload and no polling. Open a todo's own page and delete it from somewhere else, and that page tells you it's gone.

| Route | Page | What it shows |
| --- | --- | --- |
| `/` | `HologramTutorial.HomePage` | A counter — actions and state, no server involved |
| `/tasks` | `HologramTutorial.TasksPage` | The todo list — components, commands, Ecto |
| `/tasks/:id` | `HologramTutorial.TaskPage` | A single todo — route params |

## Stack

- **Elixir** ~> 1.17 (built on 1.20 / Erlang OTP 29)
- **Phoenix** 1.8 — endpoint, router and Ecto, but no LiveView in the Hologram pages
- **Hologram** 0.11 — compiles Elixir to JavaScript and runs it in the browser
- **PostgreSQL**
- **Tailwind CSS** 4 + **daisyUI** 5

## Getting started

You need Elixir, Erlang and a running PostgreSQL. Then:

```bash
mix setup
```

That installs dependencies, creates the database, runs the migration and seeds a few todos.

Now start the server — **and this is the one thing that trips everybody up:**

```bash
mix holo
```

Not `mix phx.server`. In `:dev` and `:test` the Hologram compiler and runtime are switched off unless `HOLOGRAM_START=1` is set, and `mix holo` is what sets it before handing off to Phoenix. Start with `mix phx.server` and your pages compile to nothing, leaving you with `key HologramTutorial.HomePage not found in the PLT` at request time.

Then visit [localhost:4000](http://localhost:4000).

## Layout

Hologram code lives in `app/`, separate from the usual Phoenix tree in `lib/`:

```
app/
  default_layout.ex        # the <html> shell every page renders into
  home_page.ex             # counter
  tasks_page.ex            # todo list
  task_page.ex             # single todo
  components/
    todo_form.ex           # stateful — owns the draft text
    todo_item.ex           # stateless — one row
lib/
  hologram_tutorial/       # context, schema, repo
  hologram_tutorial_web/   # endpoint, router
```

`app/` is on `elixirc_paths`, and `:hologram` is the last entry in `compilers` in `mix.exs` so it runs *after* `:elixir` and bundles freshly compiled modules rather than stale ones.

## Things worth knowing

Notes from actually building this, mostly things that fail quietly rather than loudly.

**Your layout needs a `<body>`.** If you go straight from `<head>` to `<main>`, the browser inserts a `<body>` for you and Hologram's virtual DOM no longer matches the real one. The first state change after that dies inside `patchVirtualDocument` with `Cannot read properties of undefined (reading 'key')` — which looks nothing like a missing tag.

**Event bindings without params use the string form.** `$change="my_action"` and `$click="my_action"`. The curly form is for when you're passing params: `$click={:delete, id: task.id}`. Writing `$change={:my_action}` with no params misbehaves silently — no error, the handler just doesn't do its job.

**`component.props` doesn't exist inside actions.** Props are for templates. If an action needs a prop, copy it into state in `init/3` under a *different* name — a state key with the same name as a prop shadows that prop permanently.

**Give an input its own component.** A controlled input (`value={@draft}` + `$change`) sharing state with a big list can lose its updates when the list re-renders — clearing the field after submit silently does nothing. Move the input into its own stateful component and it re-renders independently. `TodoForm` exists for exactly this reason.

**Stateless components can still fire events**, they just can't handle them. Dispatch with an explicit target: `$click={action: :delete, target: "page", params: %{id: @task.id}}`. The page's cid is always `"page"`, the layout's is `"layout"`.

**Actions run in the browser, commands run on the server.** Anything touching Ecto goes in a command; the command pushes results back to the client as an action.

**Live updates are a broadcast, not a reply.** A page joins a channel in `init/3` with `put_subscription(server, :tasks)`, and commands finish with `put_broadcast(server, :tasks, :tasks_loaded, tasks: ...)` instead of replying to the caller alone. The tab that made the change receives its own broadcast, so one call updates everybody through the same `action(:tasks_loaded, ...)` handler — there's no separate "update myself" path to keep in sync. Subscriptions are dropped automatically when you navigate away. It rides a Server-Sent Events stream (`GET /hologram/sse`); you don't configure any of it.

## Handy commands

```bash
mix holo
```

```bash
mix ecto.reset
```

```bash
mix precommit
```

If `ecto.reset` complains that the database is being accessed by other users, that's your own dev server holding its connection pool — stop it first.

## Learn more

- Hologram docs — https://hologram.page
- Hologram LLM reference — `deps/hologram/usage-rules.md` and `deps/hologram/llms-full.txt`
- Phoenix — https://hexdocs.pm/phoenix

## License

MIT. See [LICENSE](LICENSE).

Use it however you want. Copy it, fork it, rip bits out of it, teach with it, ship it — no attribution needed, no questions asked. It's a tutorial project; that's what it's for.
