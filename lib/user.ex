defmodule User do
	def assign_consumer(consumers, request_pid) do
		IO.puts("Assigning consumer")
        IO.inspect(request_pid)
        :ok
	end
end