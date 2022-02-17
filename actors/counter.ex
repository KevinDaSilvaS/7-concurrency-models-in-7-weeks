defmodule Counter do
  def start(count \\ 0) do
    spawn __MODULE__, :loop, [count]
  end

  def next(pid) do
    send pid, {:next}
  end

  def loop(count \\ 0) do
    receive do
      {:next} -> IO.puts "#{count}"
      loop(count + 1)
    end
  end
end

#pid = spawn Counter, :loop, []
#pid = spawn Counter, :loop, [4]
#send pid, {:next}
#send pid, {:next}
