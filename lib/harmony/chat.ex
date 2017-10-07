defmodule Harmony.Chat do
  @join_chat "JOIN_CHAT"
  @leave_chat "LEAVE_CHAT"
  @send_message "SEND_MESSAGE"

  def initial_state do
    %{users: [], messages: []}
  end

  def handle_message({:text, message}, req, state) do
    %{"action" => action, "data" => data} = Poison.decode!(message)

    handle_message(action, data, req, state)
  end

  def handle_message(data, req, state) do
    IO.puts "Unhandled data type: #{inspect data}"

    {:ok, req, state}
  end

  defp handle_message(@join_chat, user, req, state) do
    new_state = update_in(state, [:users], &(&1 ++ [user]))

    response = Poison.encode!(new_state)

    {:reply, {:text, response}, req, new_state}
  end

  defp handle_message(@leave_chat, user, req, state) do
    new_state = update_in(state, [:users], &(&1 -- [user]))

    response = Poison.encode!(new_state)

    {:reply, {:text, response}, req, new_state}
  end

  defp handle_message(@send_message, message, req, state) do
    new_state = update_in(state, [:messages], &(&1 ++ [message]))

    response = Poison.encode!(new_state)

    {:reply, {:text, response}, req, new_state}
  end

  defp handle_message(action, data, req, state) do
    IO.puts "Unhandled action: #{action}, data: #{inspect data}"

    {:ok, req, state}
  end
end
