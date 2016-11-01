# thoughts, rewrite this as gen_server
#import Request
defmodule Request_Generator do
    # starts the request_generator service
    # TODO: register this service
    def init() do
        spawn(&server_loop/0)
    end

    def make_request(server_pid, state_dict) do
        ref = make_ref()
        send server_pid, {:new_request, self(), ref, state_dict}
        receive do
            {:request, ref, request_pid} -> request_pid
        end
        #request_pid = Request.init(state_dict)
    end


    defp server_loop() do
        receive do
            {:new_request, caller, ref, state_dict} -> 
                request_pid = Request.init(state_dict)
                send caller, {:request, ref, request_pid}
                # some logic to forward request_pid to distribution service
                server_loop()
        end
    end


end