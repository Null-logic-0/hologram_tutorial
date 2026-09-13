defmodule HologramTutorial.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :todo, :string
    field :completed, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:todo, :completed])
    |> validate_required([:todo])
    |> validate_length(:todo, min: 3, max: 1000)
  end
end
