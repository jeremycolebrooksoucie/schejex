defmodule CountdownUser do

    @doc """
    assigns a consumer to a request_state (presumably initial state)
    """
	def assign_consumer(consumers, _request_pid) do
        {min_pid, _size} = Map.to_list(consumers) 
            |> Enum.min_by(fn({_pid, {{num, []}, _request_queue}}) -> -1 * num end)
        min_pid
	end

    @doc """
    subtracts element from count
    """
    def interpret_request_update(_update, {count, [elem | rest]}, _request_state) do
        {:continue, {count - elem, rest}}
        
    end

    @doc """
    all elements have been subtracted
    """
    def interpret_request_update(_update, {count, []}, _request_state) do
        {:complete, {count, []}}
    end

    @doc """
    Returns new consumer state corresponding to next_request_state
    """
    def start_new_request({count, _num_list}, next_request_state) do
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