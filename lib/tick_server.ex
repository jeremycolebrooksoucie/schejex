defmodule TickServer do
    use GenServer

    @rate 500

    @doc """
    Creates a new consumer with some initial_state and waits for a request
        from the scheduler. Programmed to update at a rate of @rate 
        (initialized to half a second)
    """

    @doc """
    spawns an action passed in
    """
    def start(action) do
        pid = spawn(fn -> loop(action) end)
        
    end

    @doc """
    loops at rate @rate
    """
    defp loop(action) do
        receive do
            after @rate -> action.()
                           loop(action)
        end
        
    end
end