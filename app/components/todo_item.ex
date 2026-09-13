defmodule HologramTutorial.Components.TodoItem do
  @moduledoc """
  A single todo row: completion checkbox, link to the task, delete button.

  Stateless - it holds no state of its own, so its events are dispatched with an
  explicit target at the component that owns the task list.
  """

  use Hologram.Component

  alias Hologram.UI.Link

  prop :task, :map
  prop :target, :string, default: "page"

  def template do
    ~HOLO"""
    <li class="flex w-full items-center justify-between py-3">
      <div class="flex items-center gap-3">
        <input
          type="checkbox"
          checked={@task.completed}
          $change={action: :toggle, target: @target, params: %{id: @task.id}}
          class="size-4 shrink-0 cursor-pointer accent-brand"
        />
        <Link to={HologramTutorial.TaskPage, id: @task.id}>
          <span class="{todo_class(@task.completed)} hover:underline hover:text-info transition-all">
            {@task.todo}
          </span>
        </Link>
      </div>
      <button
        $click={action: :delete, target: @target, params: %{id: @task.id}}
        class="btn btn-ghost shrink-0 text-slate-400 hover:text-red-600"
      >
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
          <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
        </svg>
      </button>
    </li>
    """
  end

  defp todo_class(true), do: "flex-1 text-slate-400 line-through"
  defp todo_class(false), do: "flex-1 text-slate-900"
end
