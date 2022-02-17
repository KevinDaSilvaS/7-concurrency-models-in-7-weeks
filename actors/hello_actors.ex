defmodule Talker do
  def loop do
    receive do
      {:greet,     name} -> IO.puts "Hello #{name}"
      {:praise,    name} -> IO.puts "#{name} amazing as always!"
      {:celebrate, name} -> IO.puts "Congrats #{name}"
      {:shutdown} -> exit :normal
    end
    loop()
  end
end

Process.flag :trap_exit, true
pid = spawn_link &Talker.loop/0
send pid, {:greet, "from the other side"}
send pid, {:praise, "Adele"}
send pid, {:celebrate, "Adele"}
send pid, {:shutdown}
receive do
  {:EXIT, _pid, reason} -> IO.puts("Talker has exited (#{reason})")
end
