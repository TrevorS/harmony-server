defmodule Harmony.ServerState do
  alias Harmony.ServerState

  defstruct connections: %{}, messages: []

  def new do
    %ServerState{}
  end

  def join(state, handle, pid) do
    put_in(state.connections[handle], pid)
  end

  def leave(state, handle) do
    state.connections[handle] |> pop_in |> elem(1)
  end

  def send(state, message) do
    update_in(state.messages, &([message | &1]))
  end

  def to_json(state) do
    users = Map.keys(state.connections)

    response = %{users: users, messages: state.messages}

    Poison.encode!(response)
  end
end
