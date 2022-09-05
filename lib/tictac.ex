defmodule Tictac do
  @moduledoc """
  this module will hold the core game creation and logic for out tictac game
  """

  alias Tictac.State

  def start(ui) do
    {:ok, state} = State.new(ui)
  end

  def check_player(player) do
    case player do
       :x -> {:ok, player}
       :o -> {:ok, player}
       _ -> {:error, :invalid_player}
    end
  end

  def place_piece(_, {:error, :invalid_location}, _), do: {:error, :invalid_location}
  def place_piece(game_board, location, player) do
    if game_board[location] !== :empty do
      {:error, :occupied}
    end
    {:ok, %{game_board | location => player}}
  end

  def play_at(game_board, column, row, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, square} <- Tictac.Square.new(column, row),
         {:ok, new_board} <- place_piece(game_board, square, valid_player),
    do: new_board
  end
end
