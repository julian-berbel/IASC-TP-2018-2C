defmodule WorkQueue do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
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

  def init(:ok) do
    { :ok, %{ consumers: [], queue: :queue.new, rr: 0 } }
  end

  defp pop(%{ queue: queue } = state) do
    { { :value, value }, newqueue } = :queue.out(queue)

    { value, %{ state | queue: newqueue } }
  end
  
  def handle_call(:pop, _from, state) do
    { message, _ } = pop(state)
    
    { :reply, message, state }
  end

  def handle_cast({ :push, message }, %{ queue: queue } = state) do
    newstate = %{ state | queue: :queue.in(message, queue) }
    { :noreply, newstate }
  end

  def handle_cast({ :add_consumer, consumer }, %{ consumers: consumers } = state) do
    newstate = %{ state | consumers: [consumer | consumers] }
    { :noreply, newstate }
  end

  def handle_cast(:deliver, %{ consumers: consumers } = state) do
    { message, newstate } = pop(state)
    Consumer.consume(Enum.at(consumers, state.rr), message)

    next = rem((state.rr + 1), Kernel.length(consumers))
    { :noreply, %{ newstate | rr: next } }
  end
end