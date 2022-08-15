class GamesController < ApplicationController
  def new
    # makes an array with 10 random letters
    @letters = (0...10).map { rand(65..90).chr }
  end

  def score
    raise
  end
end
