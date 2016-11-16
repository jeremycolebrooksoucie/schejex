defmodule Schejex do
    use Application
    def start(_type, _args) do
        IO.puts("starting")
        Scheduler.start()
        ConsumerManager.start()

        for n <- 1..11, do: Consumer.start(n)

        {:ok, self()} # please fix me
    end
end
