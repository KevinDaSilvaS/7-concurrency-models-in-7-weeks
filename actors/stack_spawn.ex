defmodule StackSpawn do
  def start() do
    spawn __MODULE__, :loop, []
  end

  def push(pid, value) do
    send pid, {:push, value}
  end

  def pop(pid) do
    send pid, {:pop}
  end

  def loop(stack \\ []) do
    receive do
      {:push, value} ->
        n_stack = [value | stack]
        IO.inspect n_stack
        loop(n_stack)

      {:pop} ->
        [_ | n_stack] = stack
        IO.inspect n_stack
        case n_stack do
          [] -> loop([])
          _  -> loop(n_stack)
        end
    end
  end
end
