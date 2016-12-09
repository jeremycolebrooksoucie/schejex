defmodule Print do
    @num_rows 15
    @num_cols 15
    @printer_name :printer


    @doc """
    prints taxis on a grid (assumes everything contained in 15x15 space)
    """
    def print_rows(positions) do
        IO.puts("\n")
        # reverses positions to key by value
        positions = Map.to_list(positions) 
            |> Enum.reduce(%{}, fn({_k, {r, c, disp}}, acc) -> 
                                Map.put(acc, {r, c}, disp) end)
        IO.puts("----------------")
        #gets each line of the grid
        lines = Enum.map(0..@num_rows, &(print_col(&1, positions)))
        IO.puts(Enum.join(lines, "\n"))
        IO.puts("----------------")
    end

    @doc """
    prints each column, ending with a newline character
    """
    def print_col(row, positions) do
        Enum.map(0..@num_cols, &(print_space(row, &1, positions))) 
            |> Enum.join("")
    end

    @doc """
    prints an individual space 
    """
    def print_space(row, col, positions) do
        Map.get(positions, {row, col}," ")        
    end

    @doc """
    called at the end of interpret_request_update. 
    Updates the position of a taxi on our grid after it moves
    Disp is string to be display. Must be a string. 
    """
    def get_update(consumerPID, row, col, disp) do
        GenServer.cast(@printer_name, {:get_update, consumerPID, row, col, disp})
    end

    @doc """
    removes an entry from the positions
    """
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
    starts printing a grid to represent taxis. Initializes to an empty 
    dictionary representing no taxis.
    """
    def start() do
        positions = %{}
        {:ok, _pid} = GenServer.start(__MODULE__, positions, name: @printer_name)
        TickServer.start(fn -> print_grid() end)
        :ok
    end

    @doc """
    casts the position updates, starts printing the grid
    """
    def handle_cast({:get_update, consumerPID, row, col, disp}, positions) do
        positions = Map.update(positions, consumerPID, {row, col, disp},
                                           fn _ -> {row, col, disp} end)
        {:noreply, positions}  
    end

    @doc """
    removes a position from the grid
    """
    def handle_cast({:remove, ref}, positions) do
        positions = Map.delete(positions, ref)
        {:noreply, positions}  
    end

    @doc """
    prints positions
    """
    def handle_cast(:print, positions) do
        print_rows(positions)
        {:noreply, positions}  
    end

    @doc """
    initializes grid
    """
    def init(initial_state) do
        # register self
        {:ok, initial_state}
    end
end