defmodule PublishSubscribe do
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
    { :ok, %{ consumers: [], queue: :queue.new } }
  end

  defp pop(state) do
    { { :value, value }, newqueue } = :queue.out(state[:queue])
    newstate = %{ state | queue: newqueue }
    { value, newstate }
  end

  def handle_call(:pop, _from, state) do
    { message, _ } = pop(state)
    
    { :reply, message, state }
  end

  def handle_cast({ :push, message }, state) do
    newstate = %{ state | queue: :queue.in(message, state[:queue]) }
    { :noreply, newstate }
  end

  def handle_cast({ :add_consumer, consumer }, state) do
    newstate = %{ state | consumers: [consumer | state[:consumers]] }
    { :noreply, newstate }
  end

  def handle_cast(:deliver, state) do
    { message, newstate } = pop(state)
    Enum.each(state[:consumers], &(Consumer.consume(&1, message)))

    { :noreply, newstate }
  end
end
