defmodule Tictac.Cli do
  @moduledoc """
  this module will contain all the hooks and handlers for rendering the UI of our game
  """

  alias Tictac.{State, Cli}

  def play() do
    Tictac.start(&Cli.handle/2)
  end

  def handle(%State{status: :initial}, :get_player) do
    IO.gets("Which player will go first?\n x or o")
    |> String.trim()
    |> String.to_atom()
  end

  def show(board, c, r) do
    [item] = for {%{col: col, row: row}, v} <- board, col === c, row === r, do: v
    if item == :empty, do: " ", else: Atom.to_string(item)
  end

  def display(board) do
    IO.puts """
#{show(board, 1, 1)} | #{show(board, 2, 1)} | #{show(board, 3, 1)}
    ---------
#{show(board, 1, 2)} | #{show(board, 2, 2)} | #{show(board, 3, 2)}
    ---------
#{show(board, 1, 3)} | #{show(board, 2, 3)} | #{show(board, 3, 3)}
    """
  end
end
