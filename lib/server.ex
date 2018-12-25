defmodule TpIasc.Server do
  use Maru.Server, otp_app: :tp_iasc
end

defmodule Router.Queue do
  use TpIasc.Server

  namespace :queue do

    get do
      json(conn, Manager.queues)
    end
    
    route_param :name, type: String do
      get do
        name = String.to_atom(params[:name])

        json(conn, Manager.stats(name))
      end

      delete do
        name = String.to_atom(params[:name])
        Manager.delete_queue(name)

        json(conn, "Queue #{name} successfully deleted.")
      end
    end

    params do
      requires :name, type: String
      requires :type, type: Atom, values: [:publish_subscribe, :work_queue]
    end

    post do
      name = String.to_atom(params[:name])
      Manager.new name, params[:type]

      json(conn, "Queue #{name} successfully created.")
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

  rescue_from NotFound, as: e do
    IO.inspect(e)

    conn
    |> put_status(404)
    |> text("Not Found")
  end

  rescue_from Unauthorized, as: e do
    IO.inspect(e)

    conn
    |> put_status(401)
    |> text("Unauthorized")
  end

  rescue_from [MatchError, RuntimeError], with: :custom_error

  rescue_from :all, as: e do
    conn
    |> put_status(Plug.Exception.status(e))
    |> text("Server Error")
  end

  defp custom_error(conn, exception) do
    conn
    |> put_status(500)
    |> text(exception.message)
  end
end
