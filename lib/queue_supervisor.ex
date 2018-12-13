defmodule QueueSupervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def new_queue(mode) do
    spec = mode(mode).child_spec([])
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def mode(:publish_subscribe) do
    PublishSubscribe
  end

  def mode(:work_queue) do
    WorkQueue
  end
end
