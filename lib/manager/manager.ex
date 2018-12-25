defmodule Manager do
  def new(queue_name, mode) do
    Queue.Supervisor.new_queue(queue_name, mode)
  end

  def post_to(queue_name, message) do
    Queue.Worker.push(queue_name, message)
  end

  def subscribe_to(queue_name, subscriber) do
    Queue.Worker.add_consumer(queue_name, subscriber)
  end

  defdelegate queues, to: Queue.Supervisor, as: :children_names
  
  defdelegate stats(name), to: Queue.Worker, as: :children_names

  defdelegate delete_queue(name), to: Queue.Worker, as: :terminate
end
