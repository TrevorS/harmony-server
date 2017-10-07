defmodule Harmony.Message do
  alias Harmony.Message

  @enforce_keys [:handle, :text]

  defstruct [:handle, :text]

  def new(handle, text) do
    %Message{handle: handle, text: text}
  end
end
