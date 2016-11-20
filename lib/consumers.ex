defmodule Consumer do
    use GenServer


    @doc """
    Creates a new consumer with some initial_state and waits for a request
        from the scheduler.
    """

    def start(initial_state) do
        {:ok, pid} = GenServer.start(__MODULE__, {initial_state, []})
        ConsumerManager.update_consumer(pid, {initial_state, []})
        pid
    end

    def init(initial_state) do
        {:ok, initial_state}
    end

    def handle_cast({:add_request, requestPID}, {dict, request_queue}) do
        # {:ok, message} = GenServer.cast(requestPID, dict)
        IO.puts("handled cast")
        {:noreply, {dict, request_queue ++ [requestPID]}}
    end

    #TODO when I get a new request, notify consumer state manager.
    def add_request(consumerPID, requestPID) do
        :io.fwrite("Starting new one! ~w~w~n", [consumerPID, requestPID])
        GenServer.cast(consumerPID, {:add_request, requestPID})
        #GenServer.call(consumerPID, requestPID)
        #call a request
        #handle it
        #update consumer_state_manager
    end

    def handle_cast({:updating_request, update_message}, {dict, [first | _rest]}) do
        User.interpret_request_update(update_message, dict, first)
    end

    def give_update(consumerPID, update_message) do

        GenServer.cast(consumerPID, {:updating_request, update_message})
        :io.fwrite("update given to ~w~n", [consumerPID])
        # give update to consumer_updater, get call from user (does this first)
        # build in logic to notify request it is done, pipe that through data stream
        # 
    end


end