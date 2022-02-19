defmodule CacheGenServer do
  use GenServer

  @cache :cache
  def start_link do
    GenServer.start_link __MODULE__, {%{}, 0}, name: @cache
  end

  def put(url, page) do
    GenServer.cast(@cache, {:put, url, page})
  end

  def get(url) do
    GenServer.call(@cache, {:get, url})
  end

  def size do
    GenServer.call(@cache, {:size})
  end

  def init(start) do
    {:ok, start}
  end

  def handle_cast({:put, url, page}, {pages, size}) do
    new_pages = Map.put pages, String.to_atom(url), page
    new_size  = size + byte_size(page)
    {:noreply, {new_pages, new_size}}
  end

  def handle_call({:get, url}, _from, {pages, size}) do
    {:reply, pages[String.to_atom(url)], {pages, size}}
  end

  def handle_call({:size}, _from, {pages, size}) do
    {:reply, size, {pages, size}}
  end
end

defmodule CacheSupervisorGenServer do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    workers = [worker(CacheGenServer, [])]
    supervise(workers, strategy: :one_for_one)
  end
end
