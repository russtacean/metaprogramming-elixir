defmodule Math do
  # {:+, [context: Elixir, import: [{1, Kernel}, {2, Kernel}]], [1, 2]}
  defmacro say({:+, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs + rhs
      IO.puts("#{lhs} plus #{rhs} equals #{result}")
      result
    end
  end

  # {:*, [context: Elixir, import: [{1, Kernel}, {2, Kernel}]], [2, 3]}
  defmacro say({:*, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs * rhs
      IO.puts("#{lhs} times #{rhs} equals #{result}")
      result
    end
  end
end
