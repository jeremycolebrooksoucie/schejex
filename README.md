# schejex
Generic scheduling module in Elixir

Our code is most easily run by typing:

iex -S mix

Mix is a file management system for elixir.


Requests can also be made while the board is running in our print function by
instead typing:

iex --sname test2 --cookie 1234 --reh test1@mint2

iex --sname test1 --cookie 1234 -S mix

These commands name an erlang node where a user can add additional requests

Finally, if elixir is not installed on your machine, please examine http://elixir-lang.org/install.html

These projects are designed to be run on command line in Mac OS X or Linux distributions


This will model a series of taxi's picking up and dropping off clients. The
taxi seemed to be a natural starting point, but our solution is designed to
be generic and can be extended by filling out template.ex. We also implemented
a simple word printing example as a proof of concept test.

We implemented a grid to model taxis. Empty taxis appear on the grid as @, 
Requests awaiting pickup appear as the first letter of their name (lowercase)
Requests in transit appear in uppercase
Taxis do not move while waiting for new requests.

Consumers: each consumer is a dictionary, thus all of the consumers is a nested
dictionary (dictionary of dictionaries)
A scheduler is 2 processes, one receives request by message, the other is the 
state management loop



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

