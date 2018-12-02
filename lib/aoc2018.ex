defmodule Aoc2018 do

  def main(day) do
    result =
      case day do
        :a1 -> Day01.a
        :b1 -> Day01.b
        :a2 -> Day02.a
        :b2 -> Day02.b
        _ -> :error
      end
    IO.inspect result
  end

end
