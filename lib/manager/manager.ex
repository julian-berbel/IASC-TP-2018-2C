defmodule Manager do
  alias Manager.Worker

  defdelegate new(name, mode \\ :publish_subscribe), to: Worker

  defdelegate post_to(queue_name, message), to: Worker

  defdelegate subscribe_to(queue_name, subscriber), to: Worker
end
