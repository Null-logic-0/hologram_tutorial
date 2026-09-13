defmodule HologramTutorial.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :todo, :string
      add :completed, :boolean, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
