defmodule Aoc2018 do

  def main(day) do
    result =
      case day do
        :a -> Day01.a
        :b -> Day01.b
        _ -> :error
      end
    IO.inspect result
  end

end
