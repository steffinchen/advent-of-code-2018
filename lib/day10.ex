defmodule Day10 do

    def a do
        get_input()
        |> step(2)
    end

    def b do
    end

    defp step(input, 0) do
        "done"
    end

    defp step(input, count) do
        print(input)

        calc_next(input)
        |> step(count-1)
    end

    defp calc_next(input) do
        Enum.map(input, fn pos -> %{
                posX: pos.posX + pos.velX,
                posY: pos.posY + pos.velY,
                velX: pos.velX,
                velY: pos.velY
            } end)
    end

    defp print(points) do
        Enum.reduce(points, Matrix.new(16, 16, " "), fn %{posX: x, posY: y}, acc ->
            Matrix.set(acc, y, x, "#")
        end)
        |> Enum.each(fn line -> IO.inspect(Enum.join(line, "")) end)
    end

    defp get_input do
       # File.read!("input/input_10.txt")
"position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>"
        |> String.replace(" ", "")
        |> String.split("\n")
        |> Enum.map(fn line ->
                Regex.named_captures(~r/position=<(?<posX>-?\d+),(?<posY>-?\d+)>velocity=<(?<velX>-?\d+),(?<velY>-?\d+)>/, line)
                |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
            end )
    end


end