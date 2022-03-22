defmodule DzenWeb.Counter do
  use GenServer
  require Ecto.Query
  alias Dzen.Repo
  ## API

  @total_sessions "total_sessions"
  @stopped_sessions "stopped_sessions"

  def start_link(_args \\ []) do
    # demo purposes only: race condition. Serialized: see global:trans
    case :global.whereis_name(__MODULE__) do
      pid when is_pid(pid) ->
        IO.puts("Skipping starting the global counter")
        :ignore

      _ ->
        GenServer.start_link(__MODULE__, %{})
    end
  end

  def total_sessions() do
    case :global.whereis_name(__MODULE__) do
      pid when is_pid(pid) ->
        GenServer.call(pid, {:total_sessions})

      _ ->
        :unknown
    end
  end

  # just a demo, not a watertight counter
  def active_sessions() do
    case :global.whereis_name(__MODULE__) do
      pid when is_pid(pid) ->
        GenServer.call(pid, {:active_sessions})

      _ ->
        :unknown
    end
  end

  def session_started() do
    case :global.whereis_name(__MODULE__) do
      pid when is_pid(pid) ->
        GenServer.cast(pid, {:session_started})

      _ ->
        :unknown
    end
  end

  def session_stopped() do
    case :global.whereis_name(__MODULE__) do
      pid when is_pid(pid) ->
        GenServer.cast(pid, {:session_stopped})

      _ ->
        :unknown
    end
  end

  ## Callbacks

  def init(_args) do
    IO.puts("Starting the global session counter")

    total_sessions = get_counter_value(@total_sessions)
    stopped_sessions = get_counter_value(@stopped_sessions)

    Repo.all(Dzen.Counter) |> IO.inspect()

    :global.register_name(__MODULE__, self())

    {:ok,
     %{
       total_sessions: total_sessions,
       stopped_sessions: stopped_sessions
     }} |> IO.inspect()
  end

  def get_counter_value(key) do
    case Dzen.Repo.get_by(Dzen.Counter, key: key) do
      %{value: v} -> v
      nil -> 0
    end
  end

  def handle_cast({:session_stopped}, state = %{stopped_sessions: stopped_sessions}) do
    state = %{state | stopped_sessions: stopped_sessions + 1}
    # increase_persistent_counter(@stopped_sessions)
    broadcast_counter_state(state)
    {:noreply, state}
  end

  def handle_cast({:session_started}, state = %{total_sessions: total_sessions}) do
    # increase_persistent_counter(@total_sessions)
    state = %{state | total_sessions: total_sessions + 1}
    broadcast_counter_state(state)
    {:noreply, state}
  end

  defp increase_persistent_counter(key) do
    Dzen.Counter
    |> Repo.get_by(key: key)
    |> Repo.update_all(inc: [value: 1])
  end

  def handle_call({:total_sessions}, _sender, state = %{total_sessions: total_sessions}) do
    {:reply, total_sessions, state}
  end

  def handle_call(
        {:active_sessions},
        _sender,
        state = %{total_sessions: total_sessions, stopped_sessions: stopped_sessions}
      ) do
    {:reply, total_sessions - stopped_sessions, state}
  end

  ## details
  defp broadcast_counter_state(%{
         total_sessions: total_sessions,
         stopped_sessions: stopped_sessions
       }) do
    Phoenix.PubSub.broadcast(
      Dzen.PubSub,
      Dzen.Names.live_counter(),
      {
        :counter_state,
        %{
          total_count: total_sessions,
          active_count: total_sessions - stopped_sessions
        }
      }
    )
  end
end
