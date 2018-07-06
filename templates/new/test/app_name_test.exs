defmodule <%= app_module %>Test do
  use ExUnit.Case
  doctest <%= app_module %>

  test "Adds numbers" do
    {:ok, data} = <%= app_module %>.init()
    assert <%= app_module %>.add(data, 1) == 101
    assert <%= app_module %>.add(data, 1) == 102
    assert <%= app_module %>.add(data, 1) == 103
  end
end
