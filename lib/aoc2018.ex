defmodule Aoc2018 do

  def main(day) do
    result =
      case day do
        :a1 -> Day01.a
        :b1 -> Day01.b
        :a2 -> Day02.a
        :b2 -> Day02.b
        :a3 -> Day03.a
        :b3 -> Day03.b
        :a4 -> Day04.a
        :b4 -> Day04.b
        :a5 -> Day05.a
        :b5 -> Day05.b
        _ -> :error
      end
    IO.inspect result
  end

end
