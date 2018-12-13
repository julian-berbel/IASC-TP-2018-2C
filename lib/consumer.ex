defmodule Consumer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end
  
  def subscribe_to(consumer, queue) do
    GenServer.cast consumer, { :subscribe_to, queue }
  end

  def consume(consumer, message) do
    GenServer.cast consumer, { :consume, message }
  end

  def init(:ok) do
    { :ok, {} }
  end

  def handle_cast({:subscribe_to, queue}, _) do
    Queue.add_consumer queue, self()
    { :noreply, {} }
  end

  def handle_cast({ :consume, message }, _) do
    IO.puts message
    { :noreply, {} }
  end
end
