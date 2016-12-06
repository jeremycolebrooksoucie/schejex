defmodule Print do
        #prints taxis on a grid (assumes everything contained in 25x25 space)
    #TODO-how to make this concurrent-no clue how to synchronize in elixir.
    #other option is to have all our positions stored and updated in a list
    #but that feels obnoxious.
    # we could also just grab positions from each consumer every x amount of time
    # just print everything, question of initialization, which feels stupid
    def print_positions(positions) do
        IO.puts("consumers")
        #print based off Consumer.handle_call
        #TODO ask how to enumerate. can use fetch/exists to update
        :timer.sleep(100)
        print_positions(positions)
    end

    #called at the end of interpret_request_update. need to do something about status
    # def get_update(consumerPID, row, col, passenger) do
    #     Map.update(status, consumerPID, {row, col, passenger},
    #                         fn _ -> {row, col, passenger} end)
    # end


#idk if gen_servers are actually necessary, we can just initialize status to something empty?
#idk what the fuck is going on

    def init() do
        status = %{}
        print_positions(status)
        status
    end

    #TODO figure out what this is
    def init(initial_state) do
        # register self
        {:ok, initial_state}
    end

    def handle_cast({:get_update}, _from, state) do
        {:noreply, state, state}  
    end

end