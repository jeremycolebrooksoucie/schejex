defmodule TaxiUser do

    @doc """
    assigns a taxi to a passenger (a consumer to a request_state)
    """
	def assign_consumer(consumers, _request_state) do
        {min_pid, _size} = Map.to_list(consumers) 
            |> Enum.min_by( fn({_pid, {_curr_pos, request_states}}) ->
                    length(request_states) end)
        min_pid
    end



    
    ####################### interpret_request_update *******************
    # these functions use pattern matching to determine the state of the
    # taxi in relationship to the passenger
    # the input format of the function is:
        # update_message : the message sent by the tick_server update function
        # {taxi_row, taxi_col, :taxi_state, carID} : the car state
        # {{start_row, start_col}, {end_row, end_col}, name} : passenger state


    @doc """
    Taxi has arrived at the passenger's destination.
    Taxi uses this "time-step" to drop off the passenger.
    """
    def interpret_request_update(
    		_update, {taxi_row, taxi_col, :occupied, carID},
    	    {{_start_row, _start_col}, {taxi_row, taxi_col}, passenger}) do

        Print.get_update(carID, taxi_row, taxi_col)
        {:complete, {taxi_row, taxi_col, :empty, carID}}
    end

	@doc """
    Taxi has arrived at the passenger's pick up point.
    Taxi uses this "time-step" to pick up the passenger.
    """
    def interpret_request_update(
    		_update, {taxi_row, taxi_col, :empty, carID}, 
    	    {{taxi_row, taxi_col}, {_end_row, _end_col}, _passenger}) do

        Print.get_update(carID, taxi_row, taxi_col)
        {:continue, {taxi_row, taxi_col, :occupied, carID}}
        
    end

	@doc """
    Taxi is empty and starting on a route to the passenger.
    Taxi uses this "time-step" to move closer to the passenger.
    """
    def interpret_request_update(
    		_update, {taxi_row, taxi_col, :empty, carID}, 
    	    {{start_row, start_col}, {_end_row, _end_col}, _passenger}) do

        Print.get_update(carID, taxi_row, taxi_col)
        {new_row, new_col} = get_next_position(taxi_row, taxi_col, 
        									   start_row, start_col)
        {:continue, {new_row, new_col, :empty, carID}}        
    end

	@doc """
    Taxi is in route to a passenger's destination.
    Taxi uses this "time-step" to move closer to the passenger's destination.
    """
    def interpret_request_update(
    		_update, {taxi_row, taxi_col, :occupied, carID}, 
    	    {{_start_row, _start_col}, {end_row, end_col}, passenger}) do
    	
        Print.get_update(carID, taxi_row, taxi_col)
        {new_row, new_col} = get_next_position(taxi_row, taxi_col, 
        									   end_row, end_col)
        {:continue, {new_row, new_col, :occupied, carID}}
    end

    @doc """
    Returns the next position between
    (curr_row, curr_col) and (dest_row, dest_col)
    """
    def get_next_position(curr_row, curr_col, dest_row, dest_col) do
    	new_row = cond do
    		curr_row > dest_row -> curr_row - 1
    		curr_row < dest_row -> curr_row + 1
    		true -> curr_row
    	end
    	new_col = cond do
    		curr_col > dest_col -> curr_col - 1
    		curr_col < dest_col -> curr_col + 1
    		true -> curr_col
    	end
    	{new_row, new_col}
 	end



    @doc """
    Returns new consumer state corresponding to next_request_state
    """
    def start_new_request(consumer_state, _next_request_state) do
        consumer_state
    end




    ####################################################################
    ##                    Startup Functions                           ##
    ####################################################################

    def start_consumers_and_updaters() do
        consumers = Enum.map(1..4, fn n -> 
            consumerPid = Consumer.start({0, 0, :empty, n})
            TickServer.start(fn -> 
            	Consumer.give_update(consumerPid, :tick) end)
            consumerPid end)
        consumers
    end

    def start_requests() do
        Request.start({{10, 5}, {5, 1}, :sally})
        Request.start({{1, 0}, {5, 2}, :craig})
        Request.start({{7, 2}, {8, 2}, :sharon})
        Request.start({{5, 2}, {10, 6}, :riya})
        Request.start({{6, 0}, {12, 1}, :ben})

        Print.start()
        
    end

end