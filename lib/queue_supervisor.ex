defmodule QueueSupervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def new_queue(name) do
    spec = Queue.child_spec(name: name)
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
