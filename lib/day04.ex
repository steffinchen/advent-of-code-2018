defmodule Day04 do

    def a do
        log_entries = get_input()

        find_guard_with_highest_total(log_entries)
        |> elem(0)
        |> find_min_most_asleep_at(log_entries)
        |> calc_result
    end

    def b do
        get_input()
        |> count_minutes_by_guard
        |> find_guard_with_highes_minute
        |> calc_result
    end

    defp find_guard_with_highes_minute(minutes_by_guard) do
        Enum.reduce(minutes_by_guard, %{},
            fn {guard, min_guard}, acc ->
                {min, count} = Enum.max_by(min_guard, fn {_, count} -> count end)
                Map.put(acc, guard, %{minute: min, count: count})
            end)
       |> Enum.max_by(fn {_, %{minute: _, count: count}} -> count end)
    end

    defp count_minutes_by_guard(entries) do
        Enum.reduce(entries, %{},
        fn entry, minutes ->
            Enum.reduce(entry.fell_asleep_at .. entry.woke_up-1,
                minutes,
                fn minute, acc ->
                    Map.update(acc, entry.guard, %{}, fn val -> Map.update(val, minute, 1, &(&1 + 1)) end)
                end)
        end)
    end

    defp calc_result(%{guard: guard, minute: minute}) do
        guard * minute
    end

    defp calc_result({guard, %{count: _, minute: minute}}) do
        guard * minute
    end

    defp find_guard_with_highest_total(all) do
        Enum.reduce(all, %{},
            fn entry, acc ->
                Map.update(acc, entry.guard, 0, &(&1 + (entry.woke_up - entry.fell_asleep_at)))
            end)
        |> Enum.max_by(fn {_, time} -> time end)
    end

    defp find_min_most_asleep_at(guard, log_entries) do
        minute = Enum.reduce(log_entries, %{},
            fn entry, minutes ->
                if entry.guard == guard do
                    count_minutes_asleep(entry, minutes)
                else
                    minutes
                end
            end)
       |> Enum.max_by(fn {_, count} -> count end)
       |> elem(0)

       %{guard: guard, minute: minute}
    end

    defp count_minutes_asleep(entry, minutes) do
        Enum.reduce(entry.fell_asleep_at .. entry.woke_up-1,
            minutes,
            fn minute, acc ->
                Map.update(acc, minute, 1, &(&1 + 1))
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
        |> Enum.reduce(%{guard: nil, fell_asleep_at: nil, consolidated: []}, &consolidate_sleep/2)
        |> Map.get(:consolidated)
    end

end