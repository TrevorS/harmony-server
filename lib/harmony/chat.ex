defmodule Harmony.Chat do
  alias Harmony.Server

  @join_chat "JOIN_CHAT"
  @leave_chat "LEAVE_CHAT"
  @send_message "SEND_MESSAGE"
  @ping "PING"
  @pong "PONG"
  @ok "OK"

  def handle_message({:text, @ping}, req, state) do
    {:reply, {:text, @pong}, req, state}
  end

  def handle_message({:text, message}, req, state) do
    %{"action" => action, "data" => data} = Poison.decode!(message)

    handle_message(action, data, req, state)
  end

  def handle_message(data, req, state) do
    IO.puts "Unhandled data type: #{inspect data}"

    {:ok, req, state}
  end

  defp handle_message(@join_chat, handle, req, state) do
    response = Server.join(handle)

    {:reply, {:text, response}, req, state}
  end

  defp handle_message(@leave_chat, handle, req, state) do
    Server.leave(handle)

    {:reply, {:text, @ok}, req, state}
  end

  defp handle_message(@send_message, message, req, state) do
    %{"handle" => handle, "text" => text} = message

    Server.send(handle, text)

    {:reply, {:text, @ok}, req, state}
  end

  defp handle_message(action, data, req, state) do
    IO.puts "Unhandled action: #{action}, data: #{inspect data}"

    {:ok, req, state}
  end
end
