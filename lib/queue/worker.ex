defmodule Queue.Worker do
  use GenServer

  def start_link([name, mode]) do
    GenServer.start_link(__MODULE__, mode, [name: name])
  end

  def push(queue, message) do
    GenServer.cast queue, { :push, message }
  end

  def add_consumer(queue, consumer) do
    GenServer.cast queue, { :add_consumer, consumer }
  end

  def deliver(queue) do
    GenServer.cast queue, :deliver
  end

  def init(mode) do
    { :ok, mode } = mode.start_link([])
    { :ok, %{ consumers: [], queue: :queue.new, mode: mode } }
  end

  defp pop(queue) do
    { { :value, message }, newqueue } = :queue.out(queue)

    { message, newqueue }
  end

  def handle_cast({ :push, message }, %{ queue: queue } = state) do
    newstate = %{ state | queue: :queue.in(message, queue) }
    { :noreply, newstate }
  end

  def handle_cast({ :add_consumer, consumer }, %{ consumers: consumers } = state) do
    newstate = %{ state | consumers: [consumer | consumers] }
    { :noreply, newstate }
  end

  def handle_cast(:deliver, %{ consumers: consumers, queue: queue, mode: mode } = state) do
    { message, new_queue } = pop(queue)
    newstate = %{ state | queue: new_queue }
    
    GenServer.cast mode, {:deliver, message, consumers}
    { :noreply, newstate }
  end
end
