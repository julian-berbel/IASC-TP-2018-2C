defmodule Queue.Mode.WorkQueue do
  use GenServer
  use DB.MessageDB

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    { :ok, 0 }
  end

  def handle_cast({ :deliver, message, consumers }, next) do
    Consumer.consume(Enum.at(consumers, next), message)

    next = rem(next + 1, Kernel.length(consumers))
    { :noreply, next }
  end
end
