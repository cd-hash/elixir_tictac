defmodule Tictac.Square do
  @enforce_keys [:row, :col]

  defstruct [:row, :col]

  @board_size 1..3

  def new(col, row) when col in @board_size and row in @board_size do
    {:ok, %Tictac.Square{row: row, col: col}}
  end
  def new(_col, _row), do: {:error, :invalid_square}

  def create_board do
    for square <- create_squares(), into: %{}, do: {square, :empty}
  end

  def create_squares do
     for c <- @board_size, r <- @board_size, into: MapSet.new(), do: %Tictac.Square{col: c, row: r}
  end
end
