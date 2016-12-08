defmodule Print do
    @num_rows 25
    @num_cols 25
    @printer_name :printer

    #TODO add border, print out at once, verify print space, figure out why it's print twice

    #prints taxis on a grid (assumes everything contained in 25x25 space)
    def print_rows(positions) do
        IO.puts("consumers")
        IO.puts("-------------------------")
        for row <- 0..@num_rows, do: print_col(row, positions)
        IO.puts("-------------------------")
    end

    #prints each column, ending with a newline
    def print_col(row, positions) do
        IO.write("|")
        for col <- 0..@num_cols, do: print_space(row, col, positions)
        IO.write("|\n")
    end

    #prints an individual space
    def print_space(row, col, positions) do
        for {_key, {r, c}} <- positions, do: check_space(r, c, row, col)
    end

    #this is broken, will write a space for every key
    #determines if a taxi is at a given position or not
    def check_space(r, c, row, col) do
         if row == r and c == col do
                IO.write("#")
            else 
                IO.write(" ")
            end
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