defmodule Consumer do
  use GenServer

  def start_link(timeout) do
    GenServer.start_link(__MODULE__, timeout, [])
  end
  
  def subscribe_to(consumer, queue) do
    GenServer.cast consumer, { :subscribe_to, queue }
  end

  def consume(consumer, message) do
    GenServer.cast consumer, { :consume, message }
  end

  def init(timeout) do
    { :ok, timeout }
  end

  def handle_cast({:subscribe_to, queue}, _) do
    Queue.Worker.add_consumer queue, self()
    { :noreply, {} }
  end

  def handle_cast({ :consume, message }, timeout) do
    Process.sleep(timeout)
    IO.puts message

    { :noreply, timeout }
  end
end
