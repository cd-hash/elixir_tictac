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

  def game_over?(game) do
    board_full? = Enum.all?(game.board, fn {_, v} -> v !== :empty end)
    if board_full? or game.winner do
      :over
    else
      :not_over
    end
  end

  def get_col(board, c) do
    for {%{col: col, row: _}, v} <- board, col === c, do: v
  end

  def get_row(board, r) do
    for {%{col: _, row: row}, v} <- board, row === r, do: v
  end

  def get_diagonals(board) do
    [(for {%{col: c, row: r}, v} <- board, r === c, do: v),
    (for {%{col: c, row: r}, v} <- board, r + c === 4, do: v)]
  end

  def play_at(game_board, column, row, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, square} <- Tictac.Square.new(column, row),
         {:ok, new_board} <- place_piece(game_board, square, valid_player),
    do: {:ok, new_board}, else: (error -> error)
  end

  def game_play(%State{status: :playing} = game) do
    player = game.turn
    with {col, row} <- game.ui.(game, :get_location),
         {:ok, updated_board} <- play_at(game.board, col, row, game.turn),
         {:ok, game} <- State.event(%{game | board: updated_board}, {:play, game.turn}),
         won? <- win_check(updated_board, player),
         IO.inspect(won?),
         {:ok, game} <- State.event(game, {:check_for_winner, won?}),
         over? <- game_over?(game),
         {:ok, game} <- State.event(game, {:game_over?, over?}),
    do: game_play(game), else: (error -> error)
  end

  def game_play(%State{status: :game_over} = game) do
    game.ui.(game, nil)
  end

  def win_check(board, player) do
    cols = Enum.map(1..3, &get_col(board, &1))
    rows = Enum.map(1..3, &get_row(board, &1))
    diagonals = get_diagonals(board)
    win? = Enum.any?(cols++rows++diagonals, &won_line(&1, player))
    if win?, do: player, else: false
  end

  def won_line(line, player), do: Enum.all?(line, &(player == &1))
end
