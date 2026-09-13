defmodule HologramTutorial.Components.TodoForm do
  @moduledoc """
  Stateful input for adding a todo.

  Owns the draft text and its validation error, so typing and clearing re-render
  only this subtree. On a valid submit it hands the text to its target component
  (the page by default) and resets itself.
  """

  use Hologram.Component

  prop :target, :string, default: "page"
  prop :min_length, :integer, default: 3
  prop :placeholder, :string, default: "What needs doing?"

  def template do
    ~HOLO"""
    <form $submit="submit" class="mt-6 flex gap-2">
      <input
        type="text"
        name="todo"
        placeholder={@placeholder}
        autocomplete="off"
        value={@draft}
        $change="update_draft"
        class="flex-1 rounded-lg border border-slate-300 px-3 py-2 text-slate-900 outline-none focus:border-brand"
      />
      <button type="submit" class="btn btn-primary">Add</button>
    </form>

    {%if @error}
      <p class="mt-2 text-sm text-red-600">{@error}</p>
    {/if}
    """
  end

  def init(props, component, _server) do
    put_state(component,
      draft: "",
      error: nil,
      submit_target: props.target,
      submit_min_length: props.min_length
    )
  end

  def action(:update_draft, params, component) do
    put_state(component, draft: params.event.value, error: nil)
  end

  def action(:submit, _params, component) do
    todo = String.trim(component.state.draft)
    min_length = component.state.submit_min_length

    if String.length(todo) < min_length do
      put_state(component, :error, "Todo must be at least #{min_length} characters.")
    else
      component
      |> put_state(draft: "", error: nil)
      |> put_action(
        name: :create_todo,
        target: component.state.submit_target,
        params: %{todo: todo}
      )
    end
  end
end
