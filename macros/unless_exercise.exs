defmodule ControlFlow do
  defmacro unless(expression, do: block) do
    quote do
      case unquote(expression) do
        true -> nil
        false -> unquote(block)
        _ -> raise "Boolean expression expected in unless, got: #{inspect(unquote(expression))}"
      end
    end
  end
end
