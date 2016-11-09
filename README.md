# schejex
Generic scheduling module in Elixir

Initialization process:
Requests first
Consumers next
Consumers initialize scheduler

Consumers: each consumer is a dictionary, thus all of the consumers is a nested dictionary (dictionary of dictionaries)
A scheduler is 2 processes, one receives request by message, the other is the state management loop

Requests are agents



User Interface:
    
    # request_state is the state of the current request
    # consumer_state_dict is a dict with consumer PID's as keys
    #   and consumer states and values
    # returns the PID of the consumer to forward request to
    schedule_request(request_state, consumer_state_dict) -> consumer PID



    # updates consumer state based on physical changes in system
    #   and currenct request
    # request_state is the state of the request being serviced
    # consumer_state, state of the consumer doing the work
    # update_data, a request from hardware regarding updates to physical state of machine
    #   could also be time increments for modeling
    update_request(request_state, consumer_state, update_data) -> new_consumer_state



    # creates hardware link and returns state
    # init_consumer_updater() -> updater_state

    # given current state of updater, updates its state and provides message to forward
    #   to consumer
    # consumer_updater(updater_state, consumer_state) -> 
        (updater_state, message_for_consumer)

