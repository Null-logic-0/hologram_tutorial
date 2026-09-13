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

      {%if @task}
        <h1 class="mt-4 text-2xl font-bold text-slate-900">{@task.todo}</h1>

        <label class="mt-6 flex cursor-pointer items-center gap-3">
          <input
            type="checkbox"
            checked={@task.completed}
            $change="toggle"
            class="size-4 shrink-0 cursor-pointer accent-brand"
          />
          <span class="text-sm text-slate-600">Completed</span>
        </label>
      {%else}
        <p class="mt-4 text-sm">This todo was deleted.</p>
      {/if}
    </div>
    """
  end

  def init(params, component, server) do
    component = put_state(component, task_id: params.id, task: load_task(params.id))

    {component, put_subscription(server, :tasks)}
  end

  def action(:toggle, _params, component) do
    put_command(component, :toggle_task, id: component.state.task_id)
  end

  def action(:tasks_loaded, params, component) do
    task = Enum.find(params.tasks, &(&1.id == component.state.task_id))

    put_state(component, :task, task)
  end

  def command(:toggle_task, params, server) do
    task = Tasks.get_task!(params.id)
    Tasks.update_task(task, %{completed: !task.completed})

    put_broadcast(server, :tasks, :tasks_loaded, tasks: load_tasks())
  end

  defp load_task(id) do
    case Tasks.get_task(id) do
      nil -> nil
      task -> to_client_map(task)
    end
  end

  defp load_tasks do
    Tasks.list_tasks()
    |> Enum.sort_by(& &1.id)
    |> Enum.map(&to_client_map/1)
  end

  defp to_client_map(task) do
    %{id: task.id, todo: task.todo, completed: task.completed}
  end
end
