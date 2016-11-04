# schejex
Generic scheduling module in Elixir

Initialization process:
Requests first
Consumers next
Consumers initialize scheduler

Consumers: each consumer is a dictionary, thus all of the consumers is a nested dictionary (dictionary of dictionaries)
A scheduler is 2 processes, one receives request by message, the other is the state management loop

Requests are agents
