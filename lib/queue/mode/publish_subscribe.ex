defmodule Queue.Mode.PublishSubscribe do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    { :ok, {} }
  end

  def handle_cast({ :deliver, message, consumers }, state) do
    Enum.each(consumers, &(Consumer.consume(&1, message)))

    { :noreply, state }
  end
end
