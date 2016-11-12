defmodule Request do
    use GenServer
    
    ##
    ## External facing RPC methods
    ##

    @doc """
    Creates a new Request with initial_state and forwards it to
        the registered scheduler process
    """
    def start(initial_state) do
        {:ok, pid} = GenServer.start(__MODULE__, initial_state)
        pid
        #forward pid to registered scheduler 

    end

    @doc """
    Returns the state of the current request at request_pid
    """
    def get_state(request_pid) do
        GenServer.call(request_pid, {:get_state})
    end


    ##
    ## GenServer Implementation
    ##

    def init(initial_state) do
        # register self
        {:ok, initial_state}
    end

    def handle_call({:get_state}, from, state) do
        {:reply, state, state}  
    end

    # def handle_cast(request, state) do
        
    # end


end


# defmodule Request do
#     def init(dict) do
#         {:ok, pid} = Agent.start(fn -> dict end)
#         pid
#     end

#     # agent PID, key -> value at key
#     def get(request_agent, key) do
#         Agent.get(request_agent, 
#                   fn dict -> Map.get(dict, key) end)
#                   #&(Map.get(&1, key)))

#     end

#     # agent PID, key, value -> :ok
#     def set(request_agent, key, value) do 
#         Agent.update(request_agent,
#                      fn dict -> %{dict | key => value} end)
#                      #&(%{&1 | key => value})) 
#         :ok
#     end
# end
