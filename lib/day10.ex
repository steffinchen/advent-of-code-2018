defmodule Day10 do

    def a do
        steps =
            get_input()
            |> find_smallest_bounding_box(nil, 0, 999999999999999)
        {"Part 2", steps-1}
    end

    defp find_smallest_bounding_box(input, previous_input, step_count, prev_size) do
        {minX, maxX} = find_min_max(input, :posX)
        {minY, maxY} = find_min_max(input, :posY)

        lenX = maxX - minX + 1
        lenY = maxY - minY + 1

        bounding_box = lenX * lenY

        if (bounding_box < prev_size) do
            calc_next(input)
            |> find_smallest_bounding_box(input, step_count + 1, bounding_box)
        else
            print(previous_input)
            step_count
        end
    end


    defp find_min_max(input, key) do
        {min, max} = Enum.min_max_by(input, fn entry -> entry[key] end)
        {min[key], max[key]}
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
        IO.inspect("Part 1:")

        {minX, maxX} = find_min_max(points, :posX)
        {minY, maxY} = find_min_max(points, :posY)

        lenX = maxX - minX + 1
        lenY = maxY - minY + 1

        Enum.reduce(points, Matrix.new(lenY, lenX, " "), fn %{posX: x, posY: y}, acc ->
            Matrix.set(acc, y-minY, x-minX, "#")
        end)
        |> Enum.each(fn line -> IO.inspect(Enum.join(line, "")) end)
    end

    defp get_input do
        File.read!("input/input_10.txt")
# "position=< 9,  1> velocity=< 0,  2>
# position=< 7,  0> velocity=<-1,  0>
# position=< 3, -2> velocity=<-1,  1>
# position=< 6, 10> velocity=<-2, -1>
# position=< 2, -4> velocity=< 2,  2>
# position=<-6, 10> velocity=< 2, -2>
# position=< 1,  8> velocity=< 1, -1>
# position=< 1,  7> velocity=< 1,  0>
# position=<-3, 11> velocity=< 1, -2>
# position=< 7,  6> velocity=<-1, -1>
# position=<-2,  3> velocity=< 1,  0>
# position=<-4,  3> velocity=< 2,  0>
# position=<10, -3> velocity=<-1,  1>
# position=< 5, 11> velocity=< 1, -2>
# position=< 4,  7> velocity=< 0, -1>
# position=< 8, -2> velocity=< 0,  1>
# position=<15,  0> velocity=<-2,  0>
# position=< 1,  6> velocity=< 1,  0>
# position=< 8,  9> velocity=< 0, -1>
# position=< 3,  3> velocity=<-1,  1>
# position=< 0,  5> velocity=< 0, -1>
# position=<-2,  2> velocity=< 2,  0>
# position=< 5, -2> velocity=< 1,  2>
# position=< 1,  4> velocity=< 2,  1>
# position=<-2,  7> velocity=< 2, -2>
# position=< 3,  6> velocity=<-1, -1>
# position=< 5,  0> velocity=< 1,  0>
# position=<-6,  0> velocity=< 2,  0>
# position=< 5,  9> velocity=< 1, -2>
# position=<14,  7> velocity=<-2,  0>
# position=<-3,  6> velocity=< 2, -1>"
        |> String.replace(" ", "")
        |> String.split("\n")
        |> Enum.map(fn line ->
                Regex.named_captures(~r/position=<(?<posX>-?\d+),(?<posY>-?\d+)>velocity=<(?<velX>-?\d+),(?<velY>-?\d+)>/, line)
                |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
            end )
    end


end