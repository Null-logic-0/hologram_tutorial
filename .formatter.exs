[
  import_deps: [:ecto, :ecto_sql, :phoenix, :hologram],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs,holo}",
    "{app,config,lib,test}/**/*.{heex,ex,exs,holo}",
    "priv/*/seeds.exs"
  ]
]
