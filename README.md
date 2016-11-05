# Schejex

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `schejex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:schejex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `schejex` is started before your application:

    ```elixir
    def application do
      [applications: [:schejex]]
    end
    ```

=======
# schejex
Generic scheduling module in Elixir

Initialization process:
Requests first
Consumers next
Consumers initialize scheduler

Consumers: each consumer is a dictionary, thus all of the consumers is a nested dictionary (dictionary of dictionaries)
A scheduler is 2 processes, one receives request by message, the other is the state management loop

Requests are agents

