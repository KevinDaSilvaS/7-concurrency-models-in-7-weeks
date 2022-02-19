defmodule CounterWC do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def deliver_page(pid, ref, page) do
    GenServer.cast pid, {:deliver_page, ref, page}
  end

  def init(_args) do
    Parser.request_page self()
    {:ok, nil}
  end

  def handle_cast({:deliver_page, ref, page}, state) do
    Parser.request_page self()

    counts = String.split(page)
             |> Enum.reduce(%{}, fn(word, counts) ->
                {_, map} = Map.get_and_update(counts, word, fn curr ->
                  case curr do
                    nil -> {curr, 1}
                    _   -> {curr, curr + 1}
                  end
                end)
              map
            end)
    IO.inspect(counts)
    Accumulator.deliver_counts ref, counts
    {:noreply, state}
  end
end

defmodule CounterSupervisorWC do
  use Supervisor

  def start_link(num_counters) do
    Supervisor.start_link __MODULE__, num_counters
  end

  def init(num_counters) do
    workers = Enum.map(1..num_counters,
      &(worker(CounterWC, [], id: "counter#{&1}")))
    supervise(workers, strategy: :one_for_one)
  end
end
