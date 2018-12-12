defmodule Mix.Tasks.Consumer do
  use Mix.Task

  def run([main_node, queue]) do
    {:ok, consumer} = Consumer.start_link()
    :rpc.call(String.to_atom(main_node), Manager, :subscribe_to, [String.to_atom(queue), consumer])

    wait()
  end

  #This seems stupid but I can't for the life of me find another way to put the process on hold
  def wait do
    Process.sleep(10000)
    wait()
  end
end
