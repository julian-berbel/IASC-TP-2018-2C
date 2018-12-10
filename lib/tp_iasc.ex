defmodule TpIasc do
  use Application

  def start(_type, _args) do
    QueueSupervisor.start_link
    Manager.start_link
  end
end
