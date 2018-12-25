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

  def stats(queue) do
    GenServer.call queue, :stats
  end

  def terminate(queue) do
    GenServer.cast queue, :terminate
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
  
  def handle_cast(:terminate, %{ name: queue_name } = state) do
    Message.clear(queue_name)
    
    Supervisor.terminate_child(Queue.Supervisor, self()) # for some reason without this line supervisor restarts the server, even though it should terminate normally
    {:stop, :normal, state}
  end

  def handle_call(:stats, %{ consumers: consumers, name: queue_name, mode: mode } = state) do
    #TODO
  end
end
