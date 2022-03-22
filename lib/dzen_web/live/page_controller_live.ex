defmodule DzenWeb.PageControllerLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <section class="phx-hero">
      <%= if (@total_count > 0) do %>
        <h1><%= @total_count %></h1>
      <% end %>

      <br>

      <%= if (@active_count > 0) do %>
        <h1><%= @active_count %></h1>
      <% end %>
    </section>

    <section class="row">
      <article class="column">
        <a href="https://github.com/d-led/d-zen">.</a>
      </article>
    </section>
    """
  end

  def mount(_params, _user, socket) do
    if connected?(socket) do
      # subscribe to the other modules sending live notifications
      DzenWeb.Endpoint.subscribe(Dzen.Names.live_counter())

      # let the system know that a session has started
      DzenWeb.Counter.session_started()

      :timer.send_after(10, self(), :init)
    end

    socket =
      socket
      |> assign(:total_count, 0)
      |> assign(:active_count, 0)

    {:ok, socket}
  end

  def terminate(_reason, socket) do
    if connected?(socket), do: DzenWeb.Counter.session_stopped()
  end

  # this is triggered upon the :init message triggered via :timer.send_after
  def handle_info(:init, socket) do
    socket =
      socket
      |> assign(:total_count, DzenWeb.Counter.total_sessions())
      |> assign(:active_count, DzenWeb.Counter.active_sessions())

    {:noreply, socket}
  end

  # this is triggered via the :counter_state message received via the "live:counter:#{node()}" PubSub channel
  def handle_info(
        {:counter_state, %{total_count: total_count, active_count: active_count}},
        socket
      ) do
    socket =
      socket
      |> assign(:total_count, total_count)
      |> assign(:active_count, active_count)

    {:noreply, socket}
  end
end
