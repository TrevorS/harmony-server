defmodule Harmony.SocketHandler do
  alias Harmony.Chat

  @behaviour :cowboy_websocket_handler

  @timeout 60_000

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    state = Chat.initial_state()

    {:ok, req, state, @timeout}
  end

  def websocket_handle(message, req, state) do
    Chat.handle_message(message, req, state)
  end

  def websocket_info(message, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
