defmodule HologramTutorialWeb.PageController do
  use HologramTutorialWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
