defmodule Accumulator do
  use GenServer

  def start_link do
    GenServer.start_link({:global, :wc_accumulator}, __MODULE__, {%{}, []})
  end

  def deliver_counts(ref, counts) do
    GenServer.cast({:global, :wc_accumulator}, {:deliver_counts, ref, counts})
  end

  def handle_cast({:deliver_counts, ref, counts}, {totals, processed_pages}) do
    if Map.get(processed_pages, ref) do
      {:no_reply, {totals, processed_pages}}
    else
      new_totals = Map.merge(totals, counts, fn _k, v1, v2 ->
        v1 + v2
      end)
      new_processed_pages = Map.put(processed_pages, ref, 1)
      Parser.processed ref
      {:noreply, {new_totals, new_processed_pages}}
    end
  end
end
