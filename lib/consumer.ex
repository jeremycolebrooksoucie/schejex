defmodule Consumer do
    use GenServer

    @user_module TaxiUser

    ##
    ## External facing RPC methods
    ##

    @doc """
    Creates a new consumer with some initial_state and waits for a request
        from the scheduler.
    """

    def start(initial_state) do
        {:ok, pid} = GenServer.start(__MODULE__, {:waiting, initial_state, []})
        ConsumerManager.update_consumer(pid, {initial_state, []})
        pid
    end


    #TODO when I get a new request, notify consumer state manager.
    def add_request(consumerPID, requestPID) do
        GenServer.call(consumerPID, {:add_request, requestPID})
    end


    def give_update(consumerPID, update_message) do
        GenServer.cast(consumerPID, {:updating_request, update_message})
        # give update to consumer_updater, get call from user
        # notifies request when done, pipe through data stream
    end



    ##
    ## GenServer Implementation
    ##    

    def init(initial_state) do
        {:ok, initial_state}
    end

    def handle_call({:add_request, requestPID}, _from, {status, user_state, 
                                                          request_queue}) do

        ConsumerManager.update_consumer(self(), {user_state, 
                    Request.get_all_states(request_queue ++ [requestPID])})

        {:reply, :ok, {status, user_state, request_queue ++ [requestPID]}}
    end

    # update request when waiting for a new request
    # start a new request and do a unit of work on it
    def handle_cast({:updating_request, update_message}, 
                    {:waiting, user_state, request_queue = 
                                              [request | _rest_requests]}) do
        # get the request state
        request_state = Request.get_state(request)

        # run code to initiate a request
        new_user_state = @user_module.start_new_request(user_state, 
                                                        request_state)

        # do a bit of work on that request
        {response, final_user_state} = 
                        @user_module.interpret_request_update(update_message, 
                                                new_user_state, request_state)

        parse_response(response, final_user_state, request_queue) 
    end

    def handle_cast({:updating_request, update_message}, 
                    {:working, user_state, request_queue = 
                                                [request | _rest_requests]}) do
        # get the request state
        request_state = Request.get_state(request)
        # do a bit of work on that request
        {response, final_user_state} = 
                        @user_module.interpret_request_update(update_message, 
                                                    user_state, request_state)

        parse_response(response, final_user_state, request_queue) 

    end

    def handle_cast({:updating_request, _update_message}, 
                    {status, user_state, []}) do
        {:noreply, {status, user_state, []}}                    
    end


    # function to delegate parsing user response messages to

    # case for finishing message in queue
    defp parse_response(:complete,  user_state, [_ | request_tail]) do 
        ConsumerManager.update_consumer(self(), {user_state, 
                                Request.get_all_states(request_tail)})
        {:noreply, {:waiting, user_state, request_tail}}
    end

    defp parse_response(:continue, user_state, request_queue) do
        ConsumerManager.update_consumer(self(), {user_state, 
                                Request.get_all_states(request_queue)})
        {:noreply, {:working, user_state, request_queue}}
    end

end