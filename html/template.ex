defmodule Template do
  import Html

  def render do
    markup do
      table id: "main-table" do
        tr class: "row" do
          for i <- 0..5 do
            td do
              text("Cell #{i}")
            end
          end
        end
      end

      div class: "container" do
        text("Some nested content")
      end
    end
  end
end
