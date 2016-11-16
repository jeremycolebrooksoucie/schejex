defmodule User do
	def assign_consumer(consumers, request_pid) do
        {min_pid, size} = Map.to_list(consumers) 
            |> Enum.min_by(fn({_pid, num}) -> num end)
		IO.puts("Assigning consumer")
        IO.inspect(request_pid)
        min_pid
	end

    def update_request(request_state, consumer_state, _update_data) do 
        consumer_state + request_state
    end
end