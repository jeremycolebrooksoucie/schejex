defmodule Scheduler do

	# initalize the state management loop and new_request handler
	def init(consumers) do
		# launch the state_management_loop with the list of consumer PIDS
		# register the state management loop as :State_Manager
		# call new_request
	end
	
	# to recieve requests via the message queue
	# assume that requests are agents
	def new_request(requestID) do
		# get updated list of consumers (via state_management loop)
		# call user-defined function to assign a consumer (returns a consumer)
		# sends a message to the consumer responsible for the new request
		send new_consumer, {:handle_request, requestID}
	end

	# consumers are represented as a nested dictionary (primary and secondary keys)
	# to keep an updated list of consumer states
	def state_management_loop(consumers) do
		receive do
			{:update_consumer, consumerPID, consumerDict} ->  # updates a consumer in the loop variable
			{:get_all_consumers} -> consumers  # handles requests for current state of consumers
		end
	end

end