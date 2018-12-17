defmodule Queue.Worker do
  use GenServer
  alias DB.MessageDB.Message

  def start_link([name, mode]) do
    GenServer.start_link(__MODULE__, [name, mode], [name: name])
  end

  def push(queue, message) do
    GenServer.cast queue, { :push, message }
    GenServer.cast queue, :deliver
  end

  def add_consumer(queue, consumer) do
    GenServer.cast queue, { :add_consumer, consumer }
  end

  def deliver(queue) do
    GenServer.cast queue, :deliver
  end

  def init([name, mode]) do
    { :ok, mode } = mode.start_link([])

    { :ok, %{ consumers: [], name: name, mode: mode } }
  end

  def handle_cast({ :push, message }, %{ name: queue_name } = state) do
    Message.push(queue_name, message)

    { :noreply, state }
  end

  def handle_cast({ :add_consumer, consumer }, %{ consumers: consumers } = state) do
    newstate = %{ state | consumers: [consumer | consumers] }

    { :noreply, newstate }
  end

  def handle_cast(:deliver, %{ consumers: consumers, name: queue_name, mode: mode } = state) do
    { :ok, message } = Message.pop(queue_name)
    
    GenServer.cast mode, {:deliver, message.content, consumers}
    { :noreply, state }
  end
end
