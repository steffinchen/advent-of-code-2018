defmodule Day04 do

    def a do
        log_entries =
            get_input()
            |> Enum.reduce(%{guard: nil, fell_asleep_at: nil, consolidated: []}, &consolidate_sleep/2)

        Map.get(log_entries, :consolidated)
        |> find_guard_with_highest_total
        |> elem(0)
        |> find_min_most_asleep_at(Map.get(log_entries, :consolidated))
        # 501 vs 493
    end

    def b do

    end

    defp find_guard_with_highest_total(all) do
        Enum.reduce(all, %{},
            fn entry, acc ->
                Map.update(acc, entry.guard, 0, &(&1 + (entry.woke_up - entry.fell_asleep_at)))
            end)
        |> Enum.max_by(fn {_, time} -> time end)
    end

    defp find_min_most_asleep_at(guard, log_entries) do
        Enum.reduce(log_entries, %{},
            fn entry, acc ->
                if entry.guard == guard do

                else
                    acc
                end
            end)
    end

    defp consolidate_sleep(entry, acc) do
        case entry.event do
            "falls asleep" -> Map.put(acc, :guard, entry.guard)
                              |> Map.put(:fell_asleep_at, entry.min)
            "wakes up" -> Map.update!(acc, :consolidated,
                            &(&1 ++ [%{guard: acc.guard, fell_asleep_at: acc.fell_asleep_at, woke_up: entry.min}]))
            _ -> acc
        end

    end

    defp parse_input(line, acc) do
        guard_id = get_guard_id(line, acc)
        captures = Regex.named_captures(~r/\[(?<day>\d{4}-\d{2}-\d{2})\s(?<hour>\d{2}):(?<min>\d{2})\]\s(Guard #\d+ )?(?<event>.+)/, line)
        {
            %{guard: guard_id, day: captures["day"], min: String.to_integer(captures["min"]), event: captures["event"]},
            guard_id
        }
    end

    defp get_guard_id(line, previous) do
        captures = Regex.named_captures(~r/Guard #(?<id>\d+)/, line)
        if captures == nil, do: previous, else: String.to_integer(captures["id"])
    end

    defp get_input do
        File.read!("input/input_04_sorted.txt")
        |> String.split("\r\n")
        |> Enum.map_reduce(0, &parse_input/2)
        |> elem(0)
    end

end