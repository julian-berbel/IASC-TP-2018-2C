defmodule Manager do
  use GenServer

  def start_link(opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  def new(queue_name) do
    GenServer.cast __MODULE__, { :new, queue_name }
  end

  def post_to(queue_name, message) do
    GenServer.cast __MODULE__, { :post_to, queue_name, message }
  end

  def subscribe_to(queue_name, subscriber) do
    GenServer.cast __MODULE__, { :subscribe_to, queue_name, subscriber }
  end

  def queues do
    GenServer.call __MODULE__, :queues
  end

  def init(:ok) do
    { :ok, %{} }
  end

  def handle_cast({ :new, queue_name }, state) do
    { _, queue } = QueueSupervisor.new_queue(queue_name)
    state = Map.put state, queue_name, queue

    { :noreply, state }
  end

  def handle_cast({ :post_to, queue_name, message }, state) do
    queue = state[queue_name]
    Queue.push(queue, message)

    { :noreply, state }
  end

  def handle_cast({ :subscribe_to, queue_name, subscriber }, state) do
    queue = state[queue_name]
    Queue.add_consumer(queue, subscriber)

    { :noreply, state }
  end

  def handle_call(:queues, _from, state) do
    { :reply, state, state }
  end
end
