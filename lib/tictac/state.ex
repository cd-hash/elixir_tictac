defmodule Tictac.State do
  @moduledoc """
  this module will be a state machine that defines all possible states in the game and their allowed changes
  """

  alias Tictac.{Square, State}

  @players [:x, :o]

  defstruct status: :initial,
                     over: false,
                     turn: nil,
                     winner: nil,
                     board: Square.create_board(),
                     ui: nil

  def name(), do: {:ok, %State{}}
  def name(ui), do: {:ok, %State{ui: ui}}
end
