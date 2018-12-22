defmodule Manager.Worker do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  def new(queue_name, mode) do
    GenServer.cast __MODULE__, { :new, queue_name, mode }
  end

  def post_to(queue_name, message) do
    GenServer.cast __MODULE__, { :post_to, queue_name, message }
  end

  def subscribe_to(queue_name, subscriber) do
    GenServer.cast __MODULE__, { :subscribe_to, queue_name, subscriber }
  end

  def init(:ok) do
    { :ok, [] }
  end

  def handle_cast({ :new, queue_name, mode }, state) do
    Queue.Supervisor.new_queue(queue_name, mode)

    { :noreply, state }
  end

  def handle_cast({ :post_to, queue_name, message }, state) do
    Queue.Worker.push(queue_name, message)

    { :noreply, state }
  end

  def handle_cast({ :subscribe_to, queue_name, subscriber }, state) do
    Queue.Worker.add_consumer(queue_name, subscriber)

    { :noreply, state }
  end
end
