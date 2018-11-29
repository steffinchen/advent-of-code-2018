defmodule Aoc2018 do

  def main(day, input) do
    result =
      case day do
        day -> Aoc2018.day01(input)
        _ -> :error
      end
    IO.inspect result
  end

  def day01(_) do
    File.read! "input/input_01.txt"
  end
end
