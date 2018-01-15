defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new_game letters are in range a-z" do
    game = Game.new_game()
    Enum.map(game.letters, &(assert &1 <= "z" and &1 >= "a"))
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "a")
    end
  end

  test "first occurance of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurance of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    game = Game.new_game("wibble")
    game = Enum.reduce(String.codepoints("wibble"), game, fn (guess, new_game) ->
      Game.make_move(new_game, guess)
    end)
    assert game.game_state == :won
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end


  test "lost game is recognized" do
    game = Game.new_game("w")
    game = Enum.reduce(String.codepoints("abcdefg"), game, fn (guess, new_game) ->
      Game.make_move(new_game, guess)
    end)
    assert game.game_state == :lost
  end
end
