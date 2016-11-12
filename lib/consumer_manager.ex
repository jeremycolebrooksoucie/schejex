defmodule ConsumerManager do
    @consumer_server_name :consumer_state_manager


    ##
    ## External facing RPC methods
    ##

    @doc """
    Called to start consumer manager and register it
    """
    def start() do
        {:ok, _pid} = GenServer.start(__MODULE__, %{}, name: @consumer_server_name)
        :ok
    end

    @doc """
    
    """
    def update_consumer(state) do
        pid = self()
        GenServer.cast(@consumer_server_name, {:update_consumer, pid, state})
    end


    def get_all_consumers() do
        GenServer.call(@consumer_server_name, {:get_all_consumers})
    end


    ##
    ## GenServer Implementation
    ##

    def init(state_dict) do
        {:ok, state_dict}
    end


    def handle_call({:get_all_consumers}, _from, state) do
        {:reply, state, state}  
    end


    def handle_cast({:update_consumer, consumer_pid, consumer_state}, state) do
        new_state = Map.put(state, consumer_pid, consumer_state)
        {:noreply, new_state}
    end
end