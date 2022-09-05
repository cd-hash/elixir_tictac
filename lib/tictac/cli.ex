defmodule Tictac.Cli do
  @moduledoc """
  this module will contain all the hooks and handlers for rendering the UI of our game
  """

  alias Tictac.{State, Cli}

  def play() do
    Tictac.start(&Cli.handle/2)
  end

  def handle(%State{status: :initial}, :get_player) do
    IO.gets("Which player will go first?\n x or o: ")
    |> String.trim()
    |> String.to_atom()
  end

  def handle(%State{status: :playing} = state, :get_location) do
    display(state.board)
    IO.puts("Where would #{state.turn} like to place your piece?\n")
    row = IO.gets("row: ") |> trimmed_int
    col = IO.gets("col: ") |> trimmed_int
    {col, row}
  end

  def handle(%State{status: :game_over} = state, nil) do
    display(state.board)
    case state.winner do
      :tie -> "Another tie? That's what's wrong with this game!!!!!"
      _ -> "Player #{Atom.to_string(state.winner)} has won the game!!!!!!"
    end
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

  def trimmed_int(str) do
    case Integer.parse(str) do
      {location, _} -> location
      :error -> :error
    end
  end
end
