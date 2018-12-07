defmodule Day06 do

    def a do
        coords = get_input()
        # find max x, y values
        {max_x, max_y} = find_max_x_y(coords)
        # iterate through grid
        # for each point, if not given coord, check distance to coords
        evaluate_grid(coords, max_x, max_y)
        # discard coords touching edges
        # calc area of remaining coords
    end

    def b do

    end

    defp evaluate_grid(coords, max_x, max_y) do
        grid = Matrix.new(max_x, max_y)
        # each row
        # each col
        # check distance to all known coords
    end

    defp find_coord_id(coords, x, y) do
        Enum.find(coords, fn coord -> coord.x == x && coord.y == y end)
    end

    defp find_max_x_y(coords) do
        c1 = Enum.max_by(coords, fn coord -> coord.x end)
        c2 = Enum.max_by(coords, fn coord -> coord.y end)
        {c1.x, c2.y}
    end

    defp get_input do
        # File.read!("input/input_06.txt")
        "1, 1
1, 6
8, 3
3, 4
5, 5
8, 9"
        |> String.split("\n")
        |> Stream.with_index
        |> Enum.map(&line_to_coords/1)
    end

    defp line_to_coords({<<x::bytes-size(1)>> <> ", " <> y, idx}) do
        %{id: idx, x: String.to_integer(x), y: String.to_integer(y)}
    end

end