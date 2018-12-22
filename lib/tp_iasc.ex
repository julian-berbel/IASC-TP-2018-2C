defmodule TpIasc do
  use Application
  use DB.MessageDB

  def start(_type, _args) do
    
    Amnesia.Schema.create([node()])
    Amnesia.start()
    
    DB.MessageDB.create(memory: [node()])
    DB.MessageDB.wait()

    Queue.Supervisor.start_link
    Manager.Supervisor.start_link
  end
end
