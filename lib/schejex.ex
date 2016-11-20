defmodule Schejex do
    use Application
    def start(_type, _args) do
        IO.puts("starting")
        Scheduler.start()
        ConsumerManager.start()

        _consumers = Enum.map(1..11, fn n -> 
            consumerPid = Consumer.start(n)
            TickServer.start(fn -> Consumer.give_update(consumerPid, :tick) end)
            consumerPid end)
        
        {:ok, self()} # please fix me
    end
end
