defmodule Day05 do

    def a do
        get_input()
        |> String.graphemes
        |> remove_opposite_polarity
        |> Enum.count
    end

    def b do
        word = get_input()
        Enum.map(?a..?z, fn(x) -> <<x :: utf8>> end)
        |> Enum.reduce(%{},
            fn letter, acc ->
                count = remove_all(word, letter)
                    |> String.graphemes
                    |> remove_opposite_polarity
                    |> Enum.count
                Map.put(acc, letter, count)
            end)
        |> IO.inspect
        |> Enum.min_by(fn {_, count} -> count end)
    end

    defp remove_all(word, letter) do
        String.replace(word, ~r/[#{String.downcase(letter)}#{String.upcase(letter)}]/, "")
    end

    defp remove_opposite_polarity(word, previous_count) do
        if previous_count == Enum.count(word) do
            word
        else
            remove_opposite_polarity(word)
        end
    end

    defp remove_opposite_polarity(word) do
        word
        |> Enum.reduce([], &react/2)
        |> remove_opposite_polarity(Enum.count(word))
    end

    defp react(curr, [prev | tail] = acc) do
        if curr != prev && (String.upcase(curr) == prev || String.downcase(curr) == prev) do
            tail
        else
            [curr | acc]
        end
    end

    defp react(curr, []) do
        [curr]
    end

    defp get_input do
        File.read!("input/input_05.txt")
        # "dabAcCaCBAcCcaDA"
    end

end