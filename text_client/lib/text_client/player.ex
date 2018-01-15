defmodule TextClient.Player do

  alias TextClient.{State, Summary, Prompter, Mover}

  def play(%State{tally: %{game_state: :won}}) do
    exit_with_message("You WON")
  end

  def play(%State{tally: %{game_state: :lost}}) do
    exit_with_message("You LOST")
  end

  def play(game = %State{tally: %{game_state: :good_guess}}) do
    continue_with_message(game, "good guess")
  end

  def play(game = %State{tally: %{game_state: :bad_guess}}) do
    continue_with_message(game, "bad guess")
  end

  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "bad guess")
  end

  def play(game) do
    continue(game)
  end

  def continue_with_message(game, msg) do
    IO.puts(msg)
    continue(game)
  end

  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.move()
    |> play()
  end

  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
