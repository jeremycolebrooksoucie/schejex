defmodule Scheduler do

	# Description of init: initalizes the scheduler module by
	#     registering the new request server as :new_request_server
	#     registering the state management loop as :consumer_state_manager
	# consumers: a nested dictionary to references consumers and their state
	def init(consumers) do
		requestServerPID = spawn(Scheduler, :new_request_loop, [])
		Process.register(requestServerPID, :new_request_server)
		stateServerPID = spawn(Scheduler, :state_management_loop, [consumers])
		Process.register(stateServerPID, :consumer_state_manager) 
	end
	
	# to recieve requests via the message queue, assume that requests are agents
	# get updated list of consumers (via state_management loop)
	# call user-defined function to assign a consumer (returns a consumer)
	# sends a message to the consumer responsible for the new request
	def new_request_loop() do
		receive do
			{:new_request, requestID} ->
				send :consumer_state_manager, {:get_all_consumers, self()}
				consumers = receive do
					{:consumers_list, consumers} -> consumers
				end
				new_consumer = User.assign_consumer(consumers)
				send new_consumer, {:handle_request, requestID}
				new_request_loop()
		end
	end

	# consumers are represented as a nested dictionary (primary and secondary keys)
	# to keep an updated list of consumer states
	def state_management_loop(consumers) do
		receive do
			{:update_consumer, consumerPID, consumerDict} ->  
				# updates a consumer in the loop variable
				state_management_loop(consumers)
			{:get_all_consumers, returnPID} -> 
				send returnPID, {:consumers_list, consumers}
				state_management_loop(consumers)
		end
	end

end