defmodule Day02 do
    
    def a do
        get_input()
        |> Enum.reduce(%{two: 0, three: 0}, &has_double_or_triple/2)
        |> checksum()
    end

    def b do 
        get_input()
        |> find_ids
        |> get_common_part
    end

    defp get_common_part(ids) do
        String.myers_difference(ids.w1, ids.w2)
        |> Enum.reduce("", 
        fn {k, v}, acc -> 
            if k == :eq, do: acc <> v, else: acc
        end)
    end

    defp find_ids(words) do
        Enum.find_value(words, false, fn w1 -> 
            match = Enum.find(words, false, fn w2 -> 
                only_one_letter_diff(w1, w2)
            end)
            if match != false, do: %{w1: w1, w2: match}, else: false
        end)
    end

    defp only_one_letter_diff(w1, w2) do     
        result = Enum.reduce(0..(String.length(w1)), 0, 
            fn x, acc -> 
                if String.at(w1, x) != String.at(w2, x) do
                    acc + 1
                else 
                    acc
                end
            end)
        result == 1
    end

    defp checksum(%{two: two, three: three}) do
        two * three
    end

    defp has_double_or_triple(w, acc) do
        letter_count = count_letters_in_word(w)
        two =  if contains_count(letter_count, 2), do: 1, else: 0
        three = if contains_count(letter_count, 3), do: 1, else: 0
        acc
        |> Map.update!(:two, &(&1 + two))
        |> Map.update!(:three, &(&1 + three))
    end

    defp count_letters_in_word(w) do
        String.graphemes(w)
        |> Enum.reduce(%{}, 
            fn c, acc -> 
                Map.update(acc, c, 1, &(&1 + 1))
            end)
    end

    defp contains_count(count, x) do
        found = Enum.find(count, nil, fn {_, v} -> v == x end)
        if found == nil, do: false, else: true
    end

    defp get_input do
        File.read!("input/input_02.txt")
        |> String.split("\n")
    end 
end