defmodule User do
	def assign_consumer(consumers, request_pid) do
        {min_pid, size} = Map.to_list(consumers) 
            |> Enum.min_by(fn({_pid, {{num, []}, request_queue}}) -> -1 * num end)
		IO.puts("Assigning consumer")
        IO.inspect(request_pid)
        min_pid
	end

    def update_request(request_state, {consumer_state, _}, _update_data) do 
        consumer_state + request_state
    end


    # when chunk of incremental work has been done but request not completed
    # {:continue, new_consumer_state}     

    # Consumer is done with request, consumer must mark request as finished
    # {:done, finished_consumer_state}

    # Request is cancelled. Consumer must mark request as cancelled
    # {:terminate, consumer_request}
    def interpret_request_update(update, {count, [elem | rest]}, request_state) do
        IO.puts("user got a request update!")
        {:continue, {count - elem, rest}}
        
    end

    def interpret_request_update(update, {count, []}, request_state) do
        IO.puts("user finishing request")
        {:complete, {count, []}}
    end

    # returns new consumer state corresponding to next_request_state
    def start_new_request({count, _num_list}, next_request_state) do
        IO.puts("user starting new request")
        IO.inspect(next_request_state)
        {count, next_request_state}
    end

end