defmodule Day07 do

    def a do
        %{all_steps: steps, dependencies: deps} = get_input()
         put_in_order(MapSet.to_list(steps), deps, [])
         |> Enum.join("")
    end

    def b do
        %{all_steps: steps, dependencies: deps} = get_input()
        work(MapSet.to_list(steps), deps, init_workers(), [], "")
    end

    defp init_workers do
        Enum.map(0..5, fn id -> %{id: id, current_task: nil, remaining: 0} end)
    end

    defp work(steps, deps, workers, current_steps) do
    end

    defp work(steps, deps, workers, current_steps, order) do
        result = Enum.map(workers, &update_worker/2)

        work(, deps, updated_workers, , order)
    end

    defp update_worker(worker, acc) do
        if worker.remaining > 0 do
            Map.update(worker, :remaining, 0, &(&1 - 1))
        else
            # TODO remove from worker,
            done_task = worker.current_task
            Map.update(worker, :current_task, nil)
            # TODO remove from current step
            # TODO add to order
            order ++ [done_task]
        end

        # find next step (check it's not in current)
        # TODO if assigned, remove step from list of steps
        step = find_next_step(steps, deps)
        if Enum.find(current_steps, step) != nil do
            worker
        else
            Map.put(worker, :current_task, step)
            |> Map.put(:remaining, 60)
        end

    end

    defp put_in_order([], _, order) do
        order
    end

    defp put_in_order(steps, deps, order) do
        step = find_next_step(steps, deps)
        put_in_order(List.delete(steps, step), remove_from_deps(step, deps),  order ++ [step])
    end

    defp remove_from_deps(step, deps) do
        Enum.map(deps, fn {key, val} -> {key, List.delete(val, step)} end)
        |> Enum.into(%{})
        |> Enum.reduce(%{}, fn {key, val}, acc -> if val == [], do: acc, else: Map.put(acc, key, val) end )
    end

    defp find_next_step(steps, deps) do
        found = Enum.find(steps, fn step -> Map.get(deps, step) == nil end)
        IO.inspect(deps)
        if found != nil,
            do: found,
            else: Enum.find(deps, fn {_, dep} -> Enum.count(dep) == 0  end)
                |> elem(0)
    end

    defp get_input do
       # File.read!("input/input_07.txt")
"Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin."
        |> String.split("\n")
        |> Enum.reduce(%{dependencies: %{}, all_steps: MapSet.new}, fn line, acc ->
                captures = Regex.named_captures(~r/Step (?<dep>[A-Z]) must be finished before step (?<step>[A-Z]) can begin/, line)
                dependencies = Map.update(acc.dependencies, captures["step"], [captures["dep"]], fn existing_deps -> existing_deps ++ [captures["dep"]] end)
                all_steps = MapSet.put(acc.all_steps, captures["dep"])
                    |>  MapSet.put( captures["step"])
                %{dependencies: dependencies, all_steps: all_steps}
            end )
    end


end