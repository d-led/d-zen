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

    Repo.all(Dzen.Counter) |> IO.inspect()

    :global.register_name(__MODULE__, self())

    {:ok, %{}}
  end

  def get_counter_value(key) do
    case Dzen.Repo.get_by(Dzen.Counter, key: key) do
      %{value: v} -> v
      nil -> 0
    end
  end

  def handle_cast({:session_stopped}, state) do
    increase_persistent_counter(@stopped_sessions)
    broadcast_counter_state()
    {:noreply, state}
  end

  def handle_cast({:session_started}, state) do
    increase_persistent_counter(@total_sessions)
    broadcast_counter_state()
    {:noreply, state}
  end

  defp increase_persistent_counter(key) do
    Repo.insert(
      %Dzen.Counter{
        key: key,
        value: 1
      },
      conflict_target: :key,
      on_conflict: [inc: [value: 1]]
    )
  end

  def handle_call({:total_sessions}, _sender, state) do
    {:reply, get_counter_value(@total_sessions), state}
  end

  def handle_call(
        {:active_sessions},
        _sender,
        state
      ) do
    {:reply, get_counter_value(@total_sessions) - get_counter_value(@stopped_sessions), state}
  end

  ## details
  defp broadcast_counter_state() do
    total_count = get_counter_value(@total_sessions)
    active_count = total_count - get_counter_value(@stopped_sessions)

    Phoenix.PubSub.broadcast(
      Dzen.PubSub,
      Dzen.Names.live_counter(),
      {
        :counter_state,
        %{
          total_count: total_count,
          active_count: active_count
        }
      }
    )
  end
end
