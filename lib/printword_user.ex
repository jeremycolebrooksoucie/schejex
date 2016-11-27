defmodule PrintWordUser do
    def assign_consumer(consumers, request_state) do
        {min_pid, _size} = Map.to_list(consumers) 
            |> Enum.min_by( fn({_pid, {_printing_word, request_states}}) ->   
                    Enum.map(request_states, &String.length/1)
                    |> Enum.reduce(0, &+/2)
                end)
        #IO.puts("Assigning consumer")
        #IO.inspect(min_pid)
        min_pid
    end



    # when chunk of incremental work has been done but request not completed
    # {:continue, new_consumer_state}     

    # Consumer is done with request, consumer must mark request as finished
    # {:done, finished_consumer_state}

    # Request is cancelled. Consumer must mark request as cancelled
    # {:terminate, consumer_request}
    def interpret_request_update(_update, [current_word | rest], _request_state) do
        #IO.puts("user got a request update!")
        IO.puts(current_word)
        {:continue, rest}
        
    end

    def interpret_request_update(_update, [], _request_state) do
        #IO.puts("user finishing request")
        {:complete, []}
    end

    # returns new consumer state corresponding to next_request_state
    def start_new_request(old_list, next_request_state) do
        #IO.puts("user starting new request")
        #IO.inspect(next_request_state)
        String.split(next_request_state, " ")
    end




    ####################################################################
    ##                    Startup Functions                           ##
    ####################################################################

    def start_consumers_and_updaters() do
        consumers = Enum.map(1..11, fn n -> 
            consumerPid = Consumer.start([])
            TickServer.start(fn -> Consumer.give_update(consumerPid, :tick) end)
            consumerPid end)
        consumers
    end

    def start_requests() do
        Request.start("fdsfrew rew fwe ghrehgr esg")
        Enum.each(1..10, fn _ ->
            Request.start("rew rfew few fedc ew tlekwjr elfj ds")
        end)
    end
end