defmodule Harmony.Server do
  use GenServer

  alias Harmony.Message
  alias Harmony.ServerState

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :harmony_server)
  end

  def join(handle) do
    GenServer.call(:harmony_server, {:join, handle})
  end

  def leave(handle) do
    GenServer.cast(:harmony_server, {:leave, handle})
  end

  def send(handle, message) do
    GenServer.cast(:harmony_server, {:send, {handle, message}})
  end

  def init(_) do
    {:ok, ServerState.new()}
  end

  def handle_call({:join, handle}, from, state) do
    {pid, _} = from

    new_state = ServerState.join(state, handle, pid)

    response = ServerState.to_json(new_state)

    broadcast(new_state.connections, response);

    {:reply, response, new_state}
  end

  def handle_cast({:leave, handle}, state) do
    new_state = ServerState.leave(state, handle)

    response = ServerState.to_json(new_state)

    broadcast(new_state.connections, response)

    {:noreply, new_state}
  end

  def handle_cast({:send, {handle, message}}, state) do
    new_message = Message.new(handle, message)

    new_state = ServerState.send(state, new_message)

    response = ServerState.to_json(new_state)

    broadcast(new_state.connections, response)

    {:noreply, new_state}
  end

  defp broadcast(connections, response) do
    Enum.each(connections, fn {_handle, connection} ->
      Kernel.send(connection, response)
    end)
  end
end
