defmodule CountdownUser do
	def assign_consumer(consumers, _request_pid) do
        {min_pid, _size} = Map.to_list(consumers) 
            |> Enum.min_by(fn({_pid, {{num, []}, _request_queue}}) -> -1 * num end)
		#IO.puts("Assigning consumer")
        #IO.inspect(request_pid)
        min_pid
	end



    # when chunk of incremental work has been done but request not completed
    # {:continue, new_consumer_state}     

    # Consumer is done with request, consumer must mark request as finished
    # {:complete, finished_consumer_state}

    # Request is cancelled. Consumer must mark request as cancelled
    # {:terminate, consumer_request}
    # TODO: this is not supported yet
    def interpret_request_update(_update, {count, [elem | rest]}, _request_state) do
        #IO.puts("user got a request update!")
        {:continue, {count - elem, rest}}
        
    end

    def interpret_request_update(_update, {count, []}, _request_state) do
        #IO.puts("user finishing request")
        {:complete, {count, []}}
    end

    # returns new consumer state corresponding to next_request_state
    def start_new_request({count, _num_list}, next_request_state) do
        #IO.puts("user starting new request")
        #IO.inspect(next_request_state)
        {count, next_request_state}
    end




    ####################################################################
    ##                    Startup Functions                           ##
    ####################################################################

    def start_consumers_and_updaters() do
        consumers = Enum.map(1..5, fn n -> 
            consumerPid = Consumer.start({n, []})
            TickServer.start(fn -> Consumer.give_update(consumerPid, :tick) end)
            consumerPid end)
        consumers
    end

    def start_requests() do
        Enum.map(1..5, fn n -> Enum.map(1..n, &(&1)) end)
            |> Enum.map(&(Request.start(&1)))
    end
end