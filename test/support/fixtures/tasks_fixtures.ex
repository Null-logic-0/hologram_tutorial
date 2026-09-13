defmodule HologramTutorial.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HologramTutorial.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        todo: "some todo"
      })
      |> HologramTutorial.Tasks.create_task()

    task
  end
end
