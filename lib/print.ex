defmodule Print do
    @num_rows 15
    @num_cols 15
    @printer_name :printer


    @doc """
    prints taxis on a grid (assumes everything contained in 25x25 space)
    """
    def print_rows(positions) do
        # reverses positions to key by value
        positions = Map.to_list(positions) 
            |> Enum.reduce(%{}, fn({k, v}, acc) -> Map.put(acc, v, "#") end)

            



        IO.puts("consumers")
        IO.puts("----------------------------")
        lines = Enum.map(0..@num_rows, &(print_col(&1, positions)))
        IO.puts(Enum.join(lines, "\n"))
        #for row <- 0..@num_rows, do: print_col(row, positions)
        IO.puts("----------------------------")
    end

    @doc """
    prints each column, ending with a newline character
    """
    def print_col(row, positions) do
        Enum.map(0..@num_cols, &(print_space(row, &1, positions))) 
            |> Enum.join("")
        #for col <- 0..@num_cols, do: print_space(row, col, positions)
        #IO.write("\n")
    end

    @doc """
    prints an individual space 
    """
    def print_space(row, col, positions) do
        Map.get(positions, {row, col}," ")        
        # IO.write(" ")
        # for {_key, {r, c}} <- positions, do: [
        #         (if (row == r and c == col), do: IO.write("#"))
        #     ]
    end

    @doc """
    called at the end of interpret_request_update. 
    Updates the position of a taxi on our grid after it moves
    """
    def get_update(consumerPID, row, col) do
        GenServer.cast(@printer_name, {:get_update, consumerPID, row, col})
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
    def handle_cast({:get_update, consumerPID, row, col}, positions) do
        positions = Map.update(positions, consumerPID, {row, col},
                                    fn _ -> {row, col} end)
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