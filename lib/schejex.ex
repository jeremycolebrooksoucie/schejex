defmodule Schejex do
    use Application
    def start(_type, _args) do
        IO.puts("starting")
        Scheduler.start()

        {:ok, self()} # please fix me
    end
end
