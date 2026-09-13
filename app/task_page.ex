defmodule HologramTutorial.TaskPage do
  use Hologram.Page

  alias Hologram.UI.Link
  alias HologramTutorial.Tasks

  route "/tasks/:id"

  param :id, :integer

  layout HologramTutorial.DefaultLayout

  def template do
    ~HOLO"""
    <div class="rounded-2xl bg-white p-8 shadow-lg ring-1 ring-slate-200">
      <Link to={HologramTutorial.TasksPage} class="text-sm text-slate-400 hover:text-brand">
        ← All todos
      </Link>

      <h1 class="mt-4 text-2xl font-bold text-slate-900">{@task.todo}</h1>

      <label class="mt-6 flex cursor-pointer items-center gap-3">
        <input
          type="checkbox"
          checked={@task.completed}
          $change="toggle"
          class="size-4 shrink-0 accent-brand cursor-pointer"
        />
        <span class="text-sm text-slate-600">Completed</span>
      </label>
    </div>
    """
  end

  def init(params, component, _server) do
    put_state(component, :task, load_task(params.id))
  end

  def action(:toggle, _params, component) do
    put_command(component, :toggle_task, id: component.state.task.id)
  end

  def action(:task_loaded, params, component) do
    put_state(component, :task, params.task)
  end

  def command(:toggle_task, params, server) do
    task = Tasks.get_task!(params.id)
    Tasks.update_task(task, %{completed: !task.completed})

    put_action(server, :task_loaded, task: load_task(params.id))
  end

  defp load_task(id) do
    task = Tasks.get_task!(id)
    %{id: task.id, todo: task.todo, completed: task.completed}
  end
end
