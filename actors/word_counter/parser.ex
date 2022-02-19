defmodule Parser do
  use GenServer

  def start_link(filename) do
    GenServer.start_link({:global, :wc_parser}, __MODULE__, [filename])
    {:ok}
  end

  def request_page(pid) do
    GenServer.cast({:global, :wc_parser}, {:request_page, pid})
  end

  def processed(ref) do
    GenServer.cast({:global, :wc_parser}, {:processed, ref})
  end

  def init(filename) do
    xml_parser = Pages.start_link(filename)
    {:ok, {%{}, xml_parser}}
  end

  def handle_cast({:request_page, pid}, {pending, xml_parser}) do
    new_pending = deliver_page(pid, pending, Pages.next(xml_parser))
    {:noreply, {new_pending, xml_parser}}
  end

  def handle_cast({:processed, ref}, {pending, xml_parser}) do
    new_pending = Map.delete(pending, ref)
    {:noreply, {new_pending, xml_parser}}
  end

  defp deliver_page(pid, pending, nil) do
    if Enum.empty?(pending) do
      # Nothing to do
      pending
    else
      {ref, prev_page} = List.last(pending)
      CounterWC.deliver_page(pid, ref, prev_page)
      Map.put(pending, ref, prev_page)
    end
  end

  defp deliver_page(pid, pending, page) do
    ref = make_ref()
    CounterWC.deliver_page(pid, ref, page)
    Map.put(pending, ref, page)
  end
end
