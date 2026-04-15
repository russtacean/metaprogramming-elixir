defmodule Setter do
  defmacro bind_name(string) do
    quote do
      # Does not clobber caller's name var due to hygiene
      name = unquote(string)
    end
  end
end
