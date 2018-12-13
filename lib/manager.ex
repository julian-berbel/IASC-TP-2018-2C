defmodule Manager do
  use GenServer

  def start_link(opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  def new(queue_name, mode \\ :publish_subscribe) do
    GenServer.cast __MODULE__, { :new, mode, queue_name }
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

  def handle_cast({ :new, mode, queue_name }, state) do
    { _, queue } = Queue.Supervisor.new_queue(mode)
    state = Map.put state, queue_name, queue

    { :noreply, state }
  end

  def handle_cast({ :post_to, queue_name, message }, state) do
    queue = state[queue_name]
    Queue.Worker.push(queue, message)

    { :noreply, state }
  end

  def handle_cast({ :subscribe_to, queue_name, subscriber }, state) do
    queue = state[queue_name]
    Queue.Worker.add_consumer(queue, subscriber)

    { :noreply, state }
  end

  def handle_call(:queues, _from, state) do
    { :reply, state, state }
  end
end
