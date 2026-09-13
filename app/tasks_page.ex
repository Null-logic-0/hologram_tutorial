defmodule HologramTutorial.TasksPage do
  use Hologram.Page

  alias HologramTutorial.Components.TodoForm
  alias HologramTutorial.Components.TodoItem
  alias HologramTutorial.Tasks

  route "/tasks"

  layout HologramTutorial.DefaultLayout

  def template do
    ~HOLO"""
    <div class="rounded-2xl bg-base-200 p-8 shadow-lg">
      <h1 class="text-2xl font-bold">Todo</h1>
      <p class="mt-1 text-sm text-slate-400">
        {@done_count} of {@total_count} done
      </p>

      <TodoForm cid="todo_form" target="page" />

      {%if @tasks == []}
        <p class="mt-6 text-center text-sm">Nothing here yet.</p>
      {%else}
        <ul class="mt-6 divide-y divide-slate-100">
          {%for task <- @tasks}
            <TodoItem task={task} target="page" />
          {/for}
        </ul>
      {/if}
    </div>
    """
  end

  def init(_params, component, server) do
    component =
      component
      |> put_state(:tasks, load_tasks())
      |> recount()

    {component, put_subscription(server, :tasks)}
  end

  # Actions (client)

  def action(:create_todo, params, component) do
    put_command(component, :create_task, todo: params.todo)
  end

  def action(:toggle, params, component) do
    put_command(component, :toggle_task, id: params.id)
  end

  def action(:delete, params, component) do
    put_command(component, :delete_task, id: params.id)
  end

  def action(:tasks_loaded, params, component) do
    component
    |> put_state(:tasks, params.tasks)
    |> recount()
  end

  # Commands (server)

  def command(:create_task, params, server) do
    Tasks.create_task(%{todo: params.todo})
    broadcast_tasks(server)
  end

  def command(:toggle_task, params, server) do
    task = Tasks.get_task!(params.id)
    Tasks.update_task(task, %{completed: !task.completed})
    broadcast_tasks(server)
  end

  def command(:delete_task, params, server) do
    params.id
    |> Tasks.get_task!()
    |> Tasks.delete_task()

    broadcast_tasks(server)
  end

  defp broadcast_tasks(server) do
    put_broadcast(server, :tasks, :tasks_loaded, tasks: load_tasks())
  end

  defp load_tasks do
    Tasks.list_tasks()
    |> Enum.sort_by(& &1.id)
    |> Enum.map(&%{id: &1.id, todo: &1.todo, completed: &1.completed})
  end

  defp recount(component) do
    tasks = component.state.tasks

    put_state(component,
      total_count: length(tasks),
      done_count: Enum.count(tasks, & &1.completed)
    )
  end
end
