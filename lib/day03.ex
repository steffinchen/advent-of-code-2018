defmodule Day03 do

    def a do
        get_input()
        |> Enum.reduce(Matrix.new(1000,1000), &put_piece_on_grid/2)
        |> count_fields_with_two_or_more

    end

    def b do
        input = get_input()
        %{overlap_ids: ids} = Enum.reduce(
            input,
            %{grid: Matrix.new(1000,1000), overlap_ids: MapSet.new},
            &put_piece_on_grid_track_overlap/2
        )

        Enum.map(input, fn line -> line.id end)
        |> MapSet.new
        |> find_id_not_in_list(ids)
    end

    defp find_id_not_in_list(all_ids, ids) do
        MapSet.difference(all_ids, ids)
    end

    defp put_piece_on_grid_track_overlap(piece, acc) do
        Enum.reduce(0..(piece.width-1), acc,
            fn x, acc1 ->
                Enum.reduce(0 .. (piece.height-1), acc1,
                fn y, acc2 ->
                    row = piece.dtop + y
                    col = piece.dleft + x
                    existing = Matrix.elem(acc2.grid, row, col)
                    %{
                        grid: Matrix.set(acc2.grid, row, col, piece.id),
                        overlap_ids: update_overlap_set(acc2.overlap_ids, existing, piece.id)
                    }
                end)
            end)
    end

    defp update_overlap_set(set, 0, _) do
        set
    end

    defp update_overlap_set(set, existing, id) do
        MapSet.put(set, existing)
        |> MapSet.put(id)
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
                    Matrix.set(acc1, row, col, val)
                end)
            end)
    end

    defp get_input do
        File.read!("input/input_03.txt")
        # "#1 @ 1,3: 4x4
        # #2 @ 3,1: 4x4
        # #3 @ 5,5: 2x2"
        |> String.split("\n")
        |> Enum.map(
            fn line ->
                Regex.named_captures(~r/#(?<id>\d+) @ (?<dleft>\d+),(?<dtop>\d+): (?<width>\d+)x(?<height>\d+)/, line)
                |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
            end)
    end

end