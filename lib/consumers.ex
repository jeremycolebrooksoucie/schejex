defmodule Consumer do
    use GenServer


    @doc """
    Creates a new consumer with some initial_state and waits for a request
        from the scheduler.
    """

    def start(initial_state) do
        {:ok, pid} = GenServer.start(__MODULE__, initial_state)
        pid
    end

    def init(initial_state) do
        {:ok, initial_state}
    end

    def handle_cast(dict, requestPID) do
        GenServer.cast(requestPID, dict)
    end

    def give_update(consumerPID, dict) do
        GenServer.cast(consumerPID, dict)
        :time.sleep(1000)
        give_update(consumerPID, dict)
    end

    #TODO when I get a new request, notify consumer state manager.
    def add_request(consumerPID, requestPID) do
        GenServer.call(consumerPID, requestPID)
        #call a request
        #handle it
        #update consumer_state_manager
    end



end

    # def init(0, state),             do:
    #     :new_request_loop
    # def init(num_consumers, state)  do
    #     {:ok, pid} = Agent.start(fn -> state end)
    #     init(num_consumers - 1, state)
    #     #initialize all consumers to initial state
    #     # (e.g. all taxi drivers start at the same position)
    #     # each consumer is a loop
    # end

    # #:update_state is user defined
    # def consumer_loop(dict, requestID) do
    #     # updates state
    #     # handles request/queue of requests
    #     receive do
    #         {:update_state, new_dict} -> #determines if done, then sends message to state_management_loop
    #             send requestID {:state_management_loop, dict}
    #             consumer_loop(new_dict, requestID)
    #         {:handle_request, new_requestID} -> #gets new request
    #             consumer_loop(dict, new_requestID)
    #     end
    # end

    # def give_update(consumerPID) do
    #     # wrapper for user defined function. 
    #     # continually sends message from user function to consumer_loop
    #     send consumerPID, {:consumer_state_manager ,dict}
    #     :timer.sleep(1000) #waits to update again
    #     give_update(consumerPID)
    # end

