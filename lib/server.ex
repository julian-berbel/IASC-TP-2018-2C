defmodule TpIasc.Server do
  use Maru.Server, otp_app: :tp_iasc
end

defmodule Router.Queue do
  use TpIasc.Server

  namespace :queue do

    get do
      json(conn, Manager.queues)
    end
    
    route_param :name, type: Atom do
      get do
        json(conn, Queue.Worker.stats(params[:name]))
      end

      post do
        Manager.new params[:name], params[:type]

        json(conn, "Queue #{params[:name]} successfully created.")
      end
    end
  end
end

defmodule Router.Homepage do
  use TpIasc.Server

  resources do
    mount Router.Queue
  end
end

defmodule TpIasc.API do
  use TpIasc.Server

  before do
    plug Plug.Logger
  end

  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Jason,
    parsers: [:urlencoded, :json, :multipart]

  mount Router.Homepage

  rescue_from :all, as: e do
    conn
    |> put_status(Plug.Exception.status(e))
    |> text("Server Error")
  end
end
