defmodule Print do
    @num_rows 30
    @num_cols 30
    @printer_name :printer

    #####################################################################
    ## External facing RPC methods                                     ##
    #####################################################################


    @doc """
    starts printing a grid to represent taxis. Initializes to an empty 
    dictionary representing no taxis.
    """
    def start() do
        positions = %{}
        {:ok, _pid} = GenServer.start(__MODULE__, 
                                      positions, name: @printer_name)
        TickServer.start(fn -> print_grid() end)
        :ok
    end

        @doc """
    called at the end of interpret_request_update. 
    Updates the position of a taxi on our grid after it moves
    Disp is string to be display. Must be a string. 
    """
    def get_update(consumerPID, row, col, disp) do
        GenServer.cast(@printer_name, {:get_update, consumerPID, 
                                       row, col, disp})
    end

    def remove_entry(entryRef) do 
        GenServer.cast(@printer_name, {:remove, entryRef})
    end

    @doc """
    prints all current taxis on a grid
    """
    def print_grid() do
        GenServer.cast(@printer_name, :print)
    end


    @doc """
    prints taxis on a grid (assumes everything contained in 25x25 space)
    """
    defp print_rows(positions) do
        # reverses positions to key by value
        positions = Map.to_list(positions) 
            |> Enum.reduce(%{}, fn({k, {r, c, disp}}, acc) -> 
                                    Map.put(acc, {r, c}, disp) end)

            
        #IO.puts("consumers")
        topbar = String.duplicate("-", @num_rows)
        IO.puts(topbar)
        text = Enum.map(0..@num_rows, &(get_row(&1, positions)))
                    |> Enum.join("\n")
        IO.puts(text)
        IO.puts(topbar)
    end

    @doc """
    Builds string representing a row
    """
    defp get_row(row, positions) do
        Enum.map(0..@num_cols, &(get_space(row, &1, positions))) 
            |> Enum.join("")
    end

    @doc """
    gets an individual space 
    """
    defp get_space(row, col, positions) do
        Map.get(positions, {row, col}," ")        
    end




    #####################################################################
    ## GenServer Implementation                                        ##
    #####################################################################


    @doc """
    casts the position updates, starts printing the grid
    """
    def handle_cast({:get_update, consumerPID, row, col, disp}, positions) do
        positions = Map.update(positions, consumerPID, {row, col, disp},
                                    fn _ -> {row, col, disp} end)
        {:noreply, positions}  
    end


    def handle_cast({:remove, ref}, positions) do
        positions = Map.delete(positions, ref)
        {:noreply, positions}  
    end

    def handle_cast(:print, positions) do
        print_rows(positions)
        {:noreply, positions}  
    end

     def init(initial_state) do
        # register self
        {:ok, initial_state}
    end

end