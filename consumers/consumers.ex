defmodule Consumer do

    def init(num_consumers, state) do
        #initialize all consumers to initial state
        # (e.g. all taxi drivers start at the same position)
        # each consumer is a loop
    end

    #:update_state is user defined
    def consumer_loop(dict, requestID) do
        # updates state
        # handles request/queue of requests
        receive do
            {:update_state, new_dict} -> #determines if done, then sends message to state_management_loop
            {:handle_request, new_requestID} -> #gets new request
        end
    end

    def give_update(consumerPID) do
        # wrapper for user defined function. 
        # continually sends message from user function to consumer_loop
    end

end