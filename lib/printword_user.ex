defmodule PrintWordUser do

    @doc """
    assigns a consumer to a request_state (presumably initial state)
    """
    def assign_consumer(consumers, _request_state) do
        {min_pid, _size} = Map.to_list(consumers) 
            |> Enum.min_by( fn({_pid, {_printing_word, request_states}}) ->   
                    Enum.map(request_states, &String.length/1)
                    |> Enum.reduce(0, &+/2)
                end)
        min_pid
    end

    @doc """
    chunk of incremental work has been done but request not completed.
    """
    def interpret_request_update(_update, [current_word | rest], _request_state) do
        IO.puts(current_word)
        {:continue, rest}        
    end

    @doc """
    Consumer is done with request, consumer marks request as finished
    """
    def interpret_request_update(_update, [], _request_state) do
        {:complete, []}
    end

    @doc """
    Returns new consumer state corresponding to next_request_state
    """
    def start_new_request(_old_list, next_request_state) do
        String.split(next_request_state, " ")
    end




    ####################################################################
    ##                    Startup Functions                           ##
    ####################################################################

    def start_consumers_and_updaters() do
        consumers = Enum.map(1..11, fn _n -> 
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