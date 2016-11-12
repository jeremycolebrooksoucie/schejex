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