defmodule Tictac do
  @moduledoc """
  this module will hold the core game creation and logic for out tictac game
  """

  def check_player(player) do
    case player do
       :x -> {:ok, player}
       :o -> {:ok, player}
       _ -> {:error, :invalid_location}
    end
  end

  def create_board do
    for square <- create_squares(), into: %{}, do: {square, :empty}
  end

  def create_squares do
     for c <- 1..3, r <- 1..3, into: MapSet.new(), do: %Tictac.Square{col: c, row: r}
  end
end
