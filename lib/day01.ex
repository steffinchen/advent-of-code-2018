defmodule Day01 do
    
    def a do
        getInput()
        |> Enum.reduce(0, fn x, acc -> x + acc end)
    end

    def b do 
        getInput()
        |> findDuplicate(%{all: MapSet.new, current: 0})
    end

    defp findDuplicate(numbers, %{all: all, current: current}) do
        result = Enum.reduce_while(numbers, %{all: all, current: current}, 
            fn x, acc ->
                curr_frequency = acc.current + x
                if MapSet.member?(acc.all, curr_frequency) do
                     {:halt, curr_frequency}
                else 
                    {:cont, updateAcc(acc, curr_frequency)}
                end
            end) 
        findDuplicate(numbers, result)
    end

    defp findDuplicate(_, x) do
        x
    end

    defp updateAcc(acc, curr_frequency) do
        Map.put(acc, :all, MapSet.put(acc.all, curr_frequency))
        |> Map.put(:current, curr_frequency)
    end

    defp getInput do
        File.read!("input/input_01.txt")
        |> String.split("\n")
        |> Enum.map(&String.to_integer/1)
    end 
end