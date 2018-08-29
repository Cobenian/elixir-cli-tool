#!/usr/bin/env elixir

defmodule ElixirCLI do
  def process_line(_code, :eof), do: :ok
  def process_line(_code, {:error, reason}), do: IO.puts(:stderr, "Failed! Cause: #{inspect reason}")
  def process_line(code, line) do
    code_to_eval = String.replace(code, "@", "\"" <> String.trim(line) <> "\"")
    {answer, _bindings} = Code.eval_string(code_to_eval) 
    render(answer)
    process_line(code, IO.read(:line))
  end
  def render(answer) when is_list(answer) do
    Enum.each(answer, fn a ->
      render(a)
    end)
  end
  def render(answer) do
    IO.puts(answer)
  end
  def process_lines(code, lines) do
    rando = random_string()
    code_to_eval = String.replace(code, "@", rando)
    bindings = Keyword.put([], String.to_atom(rando), lines)
    {answer, _bindings} = Code.eval_string(code_to_eval, bindings) 
    render(answer)
  end
  defp random_string() do
    length = 6
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> String.downcase |> binary_part(0, length)    
  end
end

args = System.argv()

if "-l" in args do
  code = args |> Enum.reject(fn x -> x == "-l" end) |> Enum.join(" ")
  ElixirCLI.process_line(code, IO.read(:line))
else
  code = args |> Enum.join(" ")
  ElixirCLI.process_lines(code, String.split(IO.read(:all), "\n") |> Enum.drop(-1))
end

