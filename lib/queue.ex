defmodule Queue do
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

  def pop(queue) do
    GenServer.call queue, :pop
  end

  def init(:ok) do
    { :ok, :queue.new }
  end

  def handle_cast({ :push, message }, state) do
    { :noreply, :queue.in(message, state) }
  end

  def handle_call(:pop , _from, state) do
    { { :value, value }, newstate } = :queue.out(state)
    { :reply, value, newstate }
  end
end
