defmodule TpIasc do
  use Application
  use DB.MessageDB

  def start(_type, _args) do
    
    Amnesia.Schema.create([node()])
    Amnesia.Fragment.activate(Message, [node()])
    Amnesia.start()
    
    DB.MessageDB.create(memory: [node()])
    DB.MessageDB.wait()

    # I comment this because the supervisor was never instantiating the actor
    # as it is a dynamic supervisor. I think we should change this yo be static
    # Queue.Supervisor.start_link
    Queue.Worker.start_link([:cola1, Queue.Mode.PublishSubscribe])
    # P.D.: we should parameterize the mode
  end
end
