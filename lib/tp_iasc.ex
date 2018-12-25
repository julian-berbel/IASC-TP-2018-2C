defmodule TpIasc do
  use Application
  use DB.MessageDB

  def start(_type, _args) do
    
    nodes = [ node() | Node.list() ]
    Amnesia.Schema.create(nodes)
    Amnesia.Fragment.activate(Message, nodes)
    Amnesia.start()
    
    DB.MessageDB.create(memory: nodes)
    DB.MessageDB.wait()

    Queue.Supervisor.start_link

    # Esto lo comento temporalmente porque al querer levantar dos nodos
    # en simultáneo levanta este server en el mismo puerto y rompe
    # Habría que mandarle un parámetro al start para saber si es el proceso
    # principal y solo ejecutar esto en ese caso
    children = [
      # TpIasc.Server
    ]

    opts = [strategy: :one_for_one, name: TpIasc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
