defmodule Setter do
  defmacro bind_name(string) do
    quote do
      # Using var! overrides hygiene and rebinds name to a new value
      # This is dangerous and should be done on a case-by-case basis
      var!(name) = unquote(string)
    end
  end
end
