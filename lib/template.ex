defmodule Skeleton do
    
    @doc """
    skeleton designed for users to design and implement applications that 
    reqiure concurrent scheduling.
    """

    @doc """
    assigns a consumer to a request_state (presumably initial state)
    """
    def assign_consumer(consumers, _request_state) do
        {min_pid, _size} = Map.to_list(consumers) 
            |> Enum.min_by( fn({_pid, {_curr_pos, request_states}}) ->
                    length(request_states) end)
        min_pid
    end

    ####################### interpret_request_update *******************
    # these functions use pattern matching to determine the state of the
    # consumer in relationship to the request. The user is expected to 
    # impelment these. The parameters are as follows:
    # interpret_request_update(
    #   _update, : the message sent by the tick_server update function
    #    {consumer_position, consumer_state, consumerID}) : the consumer state
    #    {request_start, request_end, requestID} : the request state

    

    @doc """ 
    Returns new consumer state corresponding to next_request_state
    """
    def start_new_request(consumer_state, _next_request_state) do
        consumer_state
    end

end