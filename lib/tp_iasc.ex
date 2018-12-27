defmodule TpIasc do
  use Application
  use DB.MessageDB
  alias :mnesia, as: Mnesia

  def start(_type, _args) do
    Node.connect :"main@127.0.0.1"

    case Node.list() do 
      []           -> master_start()
      [master | _] -> slave_start(master)
    end
  end

  def master_start do
    nodes = [ node() ]
    Amnesia.Schema.create(nodes)
    Amnesia.Fragment.activate(Message, nodes)
    Amnesia.start()

    DB.MessageDB.create(memory: nodes)
    DB.MessageDB.wait()

    SyncM.start

    Queue.Supervisor.start_link

    children = [
      TpIasc.Server
    ]

    opts = [strategy: :one_for_one, name: TpIasc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def slave_start(master) do
    GenServer.multi_call([master], :sync_m, {:request_join, node(), :ram_copies})
    
    Supervisor.start_link([], [strategy: :one_for_one, name: TpIasc.Supervisor])
  end
end
