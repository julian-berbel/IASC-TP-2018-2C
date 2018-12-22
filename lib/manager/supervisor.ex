defmodule Manager.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Manager.Worker, [[name: Manager.Worker]], restart: :transient)
    ]
    supervise(children, strategy: :one_for_one, max_restarts: 10, max_seconds: 2)
  end
end
