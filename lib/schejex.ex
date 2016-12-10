defmodule Schejex do
    use Application

    @user_module TaxiUser

    @doc """
    startup code for the entire schejex project
    """
    def start(_type, _args) do
        IO.puts("starting modules")
        Scheduler.start()
        ConsumerManager.start()

        @user_module.start_consumers_and_updaters()
        @user_module.start_requests()
        
        {:ok, self()}
    end
end
