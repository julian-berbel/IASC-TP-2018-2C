defmodule Queue.Supervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def new_queue(name, mode) do
    spec = Queue.Worker.child_spec([name, mode(mode)])
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def mode(:publish_subscribe) do
    Queue.Mode.PublishSubscribe
  end

  def mode(:work_queue) do
    Queue.Mode.WorkQueue
  end

  def children_names do
    children = Supervisor.which_children(__MODULE__)
    Enum.map children, fn {_, pid, _, _} -> Keyword.get Process.info(pid), :registered_name end
  end
end
