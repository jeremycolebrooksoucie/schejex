defmodule Request do
    def init(dict) do
        {:ok, pid} = Agent.start(fn -> dict end)
        pid
    end

    # agent PID, key -> value at key
    def get(request_agent, key) do
        Agent.get(request_agent, 
                  fn dict -> Map.get(dict, key) end)
                  #&(Map.get(&1, key)))

    end

    # agent PID, key, value -> :ok
    def set(request_agent, key, value) do 
        Agent.update(request_agent,
                     fn dict -> %{dict | key => value} end)
                     #&(%{&1 | key => value})) 
        :ok
    end
end
