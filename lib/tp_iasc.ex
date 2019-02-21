defmodule TpIasc do
  use Application
  use DB.MessageDB

  def start(_type, _args) do
    connect_to_cluster()

    spawn(fn -> 
      Process.sleep(1000) # If you connect to a node and immediately ask for the node list, you only get that one node back as a result
      case Node.list() do # even if there are more connected to it. Giving it a small delay allows it to connect to the rest of them.
        []           -> init_cluster()
        members      -> join_cluster(members)
      end
    end)

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

  def join_cluster(members) do
    Enum.each(members, fn member -> 
      :rpc.call(member, TpIasc, :add_cluster_member, [node()])
    end)
    update_cluster_list()
  end

  def add_cluster_member(joinee) do
    GenServer.call :sync_m, {:request_join, joinee, :ram_copies}
    update_cluster_list()
  end

  def update_cluster_list do
    spawn(fn -> 
      Process.sleep(1000)
      { :ok, file } = File.open("cluster_nodes", [:write])
      IO.binwrite(file, Enum.join(Node.list(), "\n"))
    end)
  end
end
