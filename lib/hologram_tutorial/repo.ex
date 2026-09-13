defmodule HologramTutorial.Repo do
  use Ecto.Repo,
    otp_app: :hologram_tutorial,
    adapter: Ecto.Adapters.Postgres
end
