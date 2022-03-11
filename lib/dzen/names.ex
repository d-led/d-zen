defmodule Dzen.Names do
  def live_counter(), do: "live:counter:#{node()}"
end
