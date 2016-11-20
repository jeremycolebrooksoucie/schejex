defmodule TickServer do
    use GenServer

    @rate 500

    @doc """
    Creates a new consumer with some initial_state and waits for a request
        from the scheduler.
    """

    def start(action) do
        pid = spawn(fn -> loop(action) end)
        
    end

    defp loop(action) do
        #IO.puts("foo")
        receive do
            after @rate -> action.()
                           loop(action)
            # code
        end
        
    end





end