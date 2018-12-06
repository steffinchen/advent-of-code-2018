defmodule Day05 do

    def a do
        get_input()
        |> remove_opposite_polarity
        |> String.length
    end

    def b do
        word = get_input()
        Enum.map(?a..?z, fn(x) -> <<x :: utf8>> end)
        |> Enum.reduce(%{}, 
            fn letter, acc ->
                IO.inspect(letter)
                count = String.replace(word, letter, "")
                    |> String.replace(String.upcase(letter), "")
                    |> remove_opposite_polarity
                    |> String.length
                Map.put(acc, letter, count)
            end)
        |> IO.inspect
        |> Enum.min_by(fn {_, count} -> count end)
    end

    defp remove_opposite_polarity(word, previous_count) do
        if previous_count == String.length(word) do
            word
        else
            remove_opposite_polarity(word)
        end
    end

    defp remove_opposite_polarity(word) do
        graphemes = String.graphemes(word)
        Stream.with_index(graphemes)
        |> Enum.reduce(graphemes, &check_letters/2)
        |> Enum.join("")
        |> String.replace("_", "")
        |> remove_opposite_polarity(String.length(word))
    end

    defp check_letters({_, 0}, acc) do
        acc
    end

    defp check_letters({curr, n}, acc) do
        prev = Enum.at(acc, n-1)
        if curr != prev && (String.upcase(curr) == prev || String.downcase(curr) == prev) do
            List.replace_at(acc, n, "_")
            |> List.replace_at(n-1, "_")
        else
            acc
        end
    end

    defp get_input do
        File.read!("input/input_05.txt")
        # "aacabdaAeAafAA"
        #"dabAcCaCBAcCcaDA"
        # "abAB"
        #"aabAAB"
    end

end