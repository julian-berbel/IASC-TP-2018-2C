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
end
