defmodule Tictac do
  @moduledoc """
  this module will hold the core game creation and logic for out tictac game
  """

  alias Tictac.State

  def start(ui) do
    with {:ok, game} <- State.new(ui),
        player_1 <- ui.(game, :get_player),
        {:ok, game} <- State.event(game, {:choose_p1, player_1}),
    do: game_play(game), else: (error -> error)
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
    case game_board[location] do
      nil -> {:error, :invalid_location}
      :x -> {:error, :occupied}
      :o -> {:error, :occupied}
      :empty -> {:ok, %{game_board | location => player}}
    end
  end

  def play_at(game_board, column, row, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, square} <- Tictac.Square.new(column, row),
         {:ok, new_board} <- place_piece(game_board, square, valid_player),
    do: {:ok, new_board}, else: (error -> error)
  end

  def game_play(game) do
    with {col, row} <- game.ui.(game, :get_location),
         {:ok, updated_board} <- play_at(game.board, col, row, game.turn),
         {:ok, game} <- State.event(%{game | board: updated_board}, {:play, game.turn}),
    do: game_play(game), else: (error -> error)
  end
end
