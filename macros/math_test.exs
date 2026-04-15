defmodule MathTest do
  use Assertion

  test "integers can be added and subtracted" do
    assert 1 + 1 == 2
    assert 2 + 3 == 5
    assert 1 + 1 != 3
    assert 1 > 0
    assert 1 < 2
    assert 1 <= 1
    assert 1 >= 0
    # intentional failure
    assert 5 - 5 == 10
  end

  test "integers can be multiplied and divided" do
    assert 5 * 5 == 25
    assert 10 / 2 == 5
  end

  test "unary operators and boolean expressions can be asserted" do
    assert true
    assert !false
    # intentional failure
    assert !true
  end
end
