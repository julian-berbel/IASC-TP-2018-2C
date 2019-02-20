defmodule TpIasc do
  use Application
  use DB.MessageDB

  def start(_type, _args) do
    connect_to_cluster()
    
    case Node.list() do 
      []           -> init_cluster()
      [master | _] -> join_cluster(master)
    end

    Queue.Supervisor.start_link

    Supervisor.start_link([TpIasc.Server], [strategy: :one_for_one, name: TpIasc.Supervisor])
  end

  def connect_to_cluster do
    { :ok, file } = File.open("cluster_nodes", [:read, :write])

    IO.binread(file, :all)
    |> String.split("\n")
    |> Enum.each(fn node -> Node.connect(String.to_atom(node)) end)
  end

  def init_cluster do
    nodes = [ node() ]
    Amnesia.Schema.create(nodes)
    Amnesia.Fragment.activate(Message, nodes)
    Amnesia.start()

    DB.MessageDB.create(memory: nodes)
    DB.MessageDB.wait()

    SyncM.start
  end

  def join_cluster(master) do
    GenServer.multi_call([master], :sync_m, {:request_join, node(), :ram_copies})
  end
end
