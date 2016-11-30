defmodule Schejex do
    use Application

    @user_module TaxiUser

    def start(_type, _args) do
        IO.puts("starting")
        Scheduler.start()
        ConsumerManager.start()

        @user_module.start_consumers_and_updaters()
        @user_module.start_requests()
        
        {:ok, self()} # please fix me
    end
end
