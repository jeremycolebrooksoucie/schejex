defmodule Scheduler do
	use GenServer
	@scheduler :new_request_server
	@user_module User
	##
	## Client
	##

	def start() do
		{:ok, pid} = GenServer.start(__MODULE__, [], name: @scheduler)
        pid
	end

	def schedule_new_request(requestPID) do
		GenServer.cast(@scheduler, {:new_request, requestPID})
	end


	##
	## Server callbacks
    ##
    def init(initial_state) do
        {:ok, initial_state}
    end

	def handle_cast({:new_request, requestPID}, state) do
		#consumers = ConsumerManager.get_all_consumers()
		consumers = 5
		consumerPID = @user_module.assign_consumer(consumers, requestPID)
		#Consumer.add_request(consumerPID, requestPID)
		{:noreply, state}
	end

end