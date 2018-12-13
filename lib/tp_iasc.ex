defmodule TpIasc do
  use Application

  def start(_type, _args) do
    Queue.Supervisor.start_link
    Manager.start_link
  end
end
