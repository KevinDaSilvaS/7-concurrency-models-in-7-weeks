defmodule ParallelReduce do
  def p_reduce([a], acc, func), do: func.(a, acc)
  def p_reduce(enum, acc, func) do
    parent = self()
    lists = Enum.chunk_every(enum, 2)
    processes = pmap(lists, fn(e) ->
      case e do
        [a, b] -> spawn_link(
          fn -> send(parent, {self(), func.(a, b)}) end)
        [a]  -> spawn_link(
          fn -> send(parent, {self(), a}) end)
      end
    end)

    Enum.reduce(processes, acc, fn(_pid, acc1) ->
      receive do
        {_pid, value} -> func.(value, acc1)
      end
    end)
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end

#:timer.tc fn -> Enum.reduce([1,2,3], 0, fn(x, acc) -> :timer.sleep(1000); acc + x  end) end
