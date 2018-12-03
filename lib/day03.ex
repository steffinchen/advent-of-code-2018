defmodule Day03 do

    def a do
        getInput()
        |> Enum.reduce(Matrix.new(1000,1000), &put_piece_on_grid/2)
        |> count_fields_with_two_or_more

    end

    defp count_fields_with_two_or_more(matrix) do
        Enum.reduce(matrix, 0,
            fn row, count ->
                Enum.reduce(row, count,
                fn col, acc1 ->
                    if col >=2, do: acc1 + 1, else: acc1
                end)
            end)
    end

    defp put_piece_on_grid(piece, grid) do
        Enum.reduce(0..(piece.width-1), grid,
            fn x, acc ->
                Enum.reduce(0 .. (piece.height-1), acc,
                fn y, acc1 ->
                    row = piece.dtop + y
                    col = piece.dleft + x
                    val = Matrix.elem(acc1, row, col) + 1
                    Matrix.set(acc1, row, col, val+1)
                end)
            end)
    end

    defp getInput do
        File.read!("input/input_03.txt")
        |> String.split("\n")
        |> Enum.map(
            fn line ->
                Regex.named_captures(~r/#(?<id>\d+) @ (?<dleft>\d+),(?<dtop>\d+): (?<width>\d+)x(?<height>\d+)/, line)
                |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
            end)
    end

end