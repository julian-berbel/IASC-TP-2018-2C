defmodule Mix.Tasks.Producer do
  use Mix.Task

  def run([main_node, queue, message, wait]) do
    { timeout, _ } = Integer.parse(wait)
    produce(String.to_atom(main_node), String.to_atom(queue), message, timeout)
  end

  def produce(main_node, queue, message, timeout) do
    Process.sleep(timeout)
    :rpc.call(main_node, Manager, :post_to, [queue, message])
  
    produce(main_node, queue, message, timeout)
  end
end
