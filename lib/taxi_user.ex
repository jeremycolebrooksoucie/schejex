defmodule TaxiUser do
    @empty_taxi :@

    @doc """
    assigns a taxi to a passenger (a consumer to a request_state)
    """
	def assign_consumer(consumers, {{start_row, start_col}, 
                                    {_end_row, _end_col} , 
                                    {ref, requester}}) do
        let = String.first(Atom.to_string(requester)) |> String.downcase()
        
        Print.get_update(ref, start_row, start_col, let)

        # gets total distance from taxi pos, through request_states,
        #    to end_row, end_col 
        distance = fn({taxi_row, taxi_col}, request_states) ->
            # extracts r, c points from request_states and flattens into list
            points = Enum.map(request_states, fn {pos1, pos2, _passenger} 
                                                 -> [pos1, pos2] end)
                |> List.flatten()

            # appends starting positions (taxi pos) and ending pos (request pos)
            points = [{taxi_row, taxi_col} | points] ++ [{start_row, start_col}]
            
            # creates a zip where each element is paired with the next element
            # and sums the distance between those elements
            [_h | rest] = points
            List.zip([points, rest])
                |> Enum.map(fn({{r1, c1}, {r2, c2}}) -> 
                        :math.sqrt(:math.pow(r1 - r2, 2) + 
                                   :math.pow(c1 - c2, 2)) 
                   end)
                |> Enum.reduce(0, &(&1+&2))
        end

        {min_pid, _state} = Map.to_list(consumers) 
            |> Enum.min_by( fn({_pid, {{r, c, _status, _id}, r_states}}) ->
                    #length(request_states) 
                    distance.({r, c}, r_states) end)
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
    	    {_start_pos, {taxi_row, taxi_col}, {_ref, _requester}}) do

        #let = String.first(Atom.to_string(requester)) |> String.()

        #Print.get_update(ref, taxi_row, taxi_col, "*")
        Print.get_update(carID, taxi_row, taxi_col, @empty_taxi)
        {:complete, {taxi_row, taxi_col, :empty, carID}}
    end

	@doc """
    Taxi has arrived at the passenger's pick up point.
    Taxi uses this "time-step" to pick up the passenger.
    """
    def interpret_request_update(
    		_update, {taxi_row, taxi_col, :empty, carID}, 
    	    {{taxi_row, taxi_col}, {_end_row, _end_col}, {ref, requester}}) do        
        Print.remove_entry(ref)
        let = String.first(Atom.to_string(requester)) |> String.upcase()
        Print.get_update(carID, taxi_row, taxi_col, let)
        {:continue, {taxi_row, taxi_col, :occupied, carID}}
        
    end

	@doc """
    Taxi is empty and starting on a route to the passenger.
    Taxi uses this "time-step" to move closer to the passenger.
    """
    def interpret_request_update(
    		_update, {taxi_row, taxi_col, :empty, carID}, 
    	    {{start_row, start_col}, {_end_row, _end_col}, _passenger}) do

        Print.get_update(carID, taxi_row, taxi_col, @empty_taxi)
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
    	    {{_start_row, _start_col}, {end_row, end_col}, {_ref, requester}}) do
        
        let = String.first(Atom.to_string(requester)) |> String.upcase()
        Print.get_update(carID, taxi_row, taxi_col, let)
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
        consumers = Enum.map(1..10, fn n -> 
            consumerPid = Consumer.start({0, 0, :empty, n})
            TickServer.start(fn -> 
            	Consumer.give_update(consumerPid, :tick) end)
            consumerPid end)
        consumers
    end

    def start_requests() do
        Request.start({{10, 5}, {5, 1}, {make_ref, :sally}})
        Request.start({{1, 0}, {15, 2}, {make_ref, :craig}})
        Request.start({{17, 2}, {8, 2}, {make_ref, :sharon}})
        Request.start({{15, 2}, {10, 6}, {make_ref, :riya}})
        Request.start({{6, 0}, {12, 1}, {make_ref, :ben}})
        Print.start()
    
    end





    ####################################################################
    ##                Repl Functions for Testing                       ##
    ####################################################################


    def rand_tuple() do
        {round(:rand.uniform * 30), round(:rand.uniform * 30)} 
    end

    def start_random_request(name) do
        Request.start({rand_tuple(), rand_tuple(), {make_ref, name}})
    end

    def start_request(name, start, dest) do
        Request.start({start, dest, {make_ref, name}}) 
    end
end