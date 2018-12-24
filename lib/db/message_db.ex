use Amnesia
alias :mnesia, as: Mnesia

defdatabase DB.MessageDB do
  deftable Message

  deftable Message, [{:id, autoincrement}, :queue_name, :content], type: :ordered_set do
    @type t :: %Message{id: non_neg_integer(), queue_name: term, content: String.t}

    ## Public Interface

    def push(queue_name, message) do
      fn ->
        new = Message.write(%Message{queue_name: queue_name, content: message})

        {:ok, new}
      end
      |> Amnesia.Fragment.transaction!
    end

    def pop(queue_name) do
      fn ->
        case fetch_first(queue_name) do
          nil ->
            {:error, :empty_queue}
          first ->
            Message.delete(first)

            {:ok, first}
        end
      end
      |> Amnesia.Fragment.transaction!
    end

    def all do
      fn -> fetch_all() end
      |> Amnesia.Fragment.transaction!
    end

    ## Auxiliary Functions

    defp fetch_all do
      Mnesia.select(Message, [{match(), [guard_all_ids()], result()}])
      |> Enum.map(&pack/1)
    end

    defp fetch_first(queue_name) do
      case Mnesia.select(Message, [{match(), [guard_queue_name(queue_name)], result()}]) do
        []     -> nil
        [first | _] -> first |> pack
      end
    end

    defp pack([id, queue_name, content]) do
      %Message{id: id, queue_name: queue_name, content: content}
    end

    defp match,                        do: {Message, :"$1", :"$2", :"$3"}
    defp guard_all_ids,                do: {:>, :"$1", 0}
    defp guard_queue_name(queue_name), do: {:==, :"$2", queue_name}
    defp result,                       do: [:"$$"]
  end
end
