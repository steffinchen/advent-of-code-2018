defmodule Day05 do

    def a do
        get_input()
        |> remove_opposite_polarity
    end

    def b do

    end

    defp remove_opposite_polarity(word) do
        graphemes = String.graphemes(word)
        Stream.with_index(graphemes)
        |> Enum.reduce(graphemes,
            fn {curr, n}, acc ->
                prev = Enum.at(acc, n-1)
                if String.upcase(curr) == prev || String.downcase(curr) == prev do
                    List.replace_at(acc, n, "_")
                    |> List.replace_at(n-1, "_")
                else
                    acc
                end
            end)
        |> Enum.reduce("", fn c, word -> if c != "_", do: word <> c, else: word end)
    end

    defp get_input do
        # File.read!("input/input_04_sorted.txt")
        "dabAcCaCBAcCcaDA"
    end

end