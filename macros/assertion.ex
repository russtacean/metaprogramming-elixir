defmodule Assertion do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :tests, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        Assertion.Test.run(@tests, __MODULE__)
      end
    end
  end

  defmacro test(description, do: block) do
    test_func = String.to_atom(description)

    quote do
      @tests {unquote(test_func), unquote(description)}
      def unquote(test_func)(), do: unquote(block)
    end
  end

  # Infix operators have AST shape like
  # {:==, [context: Elixir, imports: [{2, Kernel}]], [5, 5]}
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end

  # Unary operators have AST shape like
  # {:!, [context: Elixir, imports: [{1, Kernel}]], [true]}
  defmacro assert({operator, _, [operand]}) do
    quote bind_quoted: [operator: operator, operand: operand] do
      Assertion.Test.assert(operator, operand)
    end
  end

  defmacro assert(boolExpr) when is_boolean(boolExpr) do
    quote bind_quoted: [boolExpr: boolExpr] do
      Assertion.Test.assert(boolExpr)
    end
  end
end

defmodule Assertion.Test do
  def run(tests, module) do
    Enum.each(tests, fn {test_func, description} ->
      Task.async(fn ->
        case apply(module, test_func, []) do
          :ok ->
            IO.write(".")

          {:fail, reason} ->
            IO.puts("""
            =========================
            FAILURE: #{description}
            =========================
            #{reason}
            """)
        end
      end)
    end)
  end

  def assert(:==, lhs, rhs) when lhs == rhs do
    :ok
  end

  def assert(:==, lhs, rhs) do
    {:fail,
     """
     FAILURE:
       Expected: #{inspect(lhs)}
       to be equal to: #{inspect(rhs)}
     """}
  end

  def assert(:!=, lhs, rhs) when lhs != rhs do
    :ok
  end

  def assert(:!=, lhs, rhs) do
    {:fail,
     """
     FAILURE: #{inspect(lhs)} to be not equal to: #{inspect(rhs)}
     Expected: #{inspect(lhs)}
       to be not equal to: #{inspect(rhs)}
     """}
  end

  def assert(:>, lhs, rhs) when lhs > rhs do
    :ok
  end

  def assert(:>, lhs, rhs) do
    {:fail,
     """
     FAILURE:
       Expected: #{inspect(lhs)}
       to be greater than: #{inspect(rhs)}
     """}
  end

  def assert(:<, lhs, rhs) when lhs < rhs do
    :ok
  end

  def assert(:<, lhs, rhs) do
    {:fail,
     """
     FAILURE: #{inspect(lhs)} to be less than: #{inspect(rhs)}
     """}
  end

  def assert(:<=, lhs, rhs) when lhs <= rhs do
    :ok
  end

  def assert(:<=, lhs, rhs) do
    {:fail,
     """
     FAILURE: #{inspect(lhs)} to be less than or equal to: #{inspect(rhs)}
     Expected: #{inspect(lhs)}
       to be less than or equal to: #{inspect(rhs)}
     """}
  end

  def assert(:>=, lhs, rhs) when lhs >= rhs do
    :ok
  end

  def assert(:>=, lhs, rhs) do
    {:fail,
     """
     FAILURE: #{inspect(lhs)} to be greater than or equal to: #{inspect(rhs)}
     Expected: #{inspect(lhs)}
       to be greater than or equal to: #{inspect(rhs)}
     """}
  end

  def assert(:!, operand) when not operand, do: :ok

  def assert(:!, operand) do
    {:fail,
     """
     FAILURE:
       Expected: #{inspect(operand)}
       to be true after negation
     """}
  end

  def assert(boolExpr) when is_boolean(boolExpr) do
    if boolExpr, do: :ok, else: {:fail, "Expected true, got false"}
  end
end
