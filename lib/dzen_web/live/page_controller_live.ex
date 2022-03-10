defmodule DzenWeb.PageControllerLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <section class="phx-hero">
      <h1><%= @total_count %></h1>
      <br>
      <h1><%= @active_count %></h1>
    </section>

    <section class="row">
      <article class="column">
      .
      </article>
    </section>
    """
  end

  def mount(_params, _user, socket) do
    socket = socket
    |> assign(:total_count, 1)
    |> assign(:active_count, 1)
    {:ok, socket }
  end
end
