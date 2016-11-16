defmodule Consumer do
    use GenServer


    @doc """
    Creates a new consumer with some initial_state and waits for a request
        from the scheduler.
    """

    def start(initial_state) do
        {:ok, pid} = GenServer.start(__MODULE__, initial_state)
        ConsumerManager.update_consumer(pid, initial_state)
        pid
    end

    def init(initial_state) do
        {:ok, initial_state}
    end

    def handle_cast(dict, requestPID) do
        GenServer.cast(requestPID, dict)
    end

    #TODO when I get a new request, notify consumer state manager.
    def add_request(consumerPID, requestPID) do
        :io.fwrite("Starting new one! ~w~w~n", [consumerPID, requestPID])
        #GenServer.call(consumerPID, requestPID)
        #call a request
        #handle it
        #update consumer_state_manager
    end



end