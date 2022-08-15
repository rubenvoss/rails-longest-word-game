# loading uri and json
require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    # makes an array with 10 random letters
    @letters = (0...10).map { rand(65..90).chr }
  end

  def score
    @user_word = params["word"]
    @word_english = english?
    # raise
  end

  def english?
    # is the word an english word? -- checks with the api
    # returns true or false
    uri = URI.open("https://wagon-dictionary.herokuapp.com/#{@user_word}").read
    JSON.parse(uri)["found"]
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)

    # start a time
    time = end_time - start_time

    ###### is the word an english word? ######
    ###### check with the api if 'attempt' is an english word ######
    # fetch api data (which is a hash with values)
    # word_data == true if 'attempt' is an english word
    word_english = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    word_english = JSON.parse(word_english)["found"]


    ###### does every letter of the 'attempt' appear in the grid? ######
    # make string uppercase
    attempt_array = attempt.upcase
    # turn 'attempt' string into an array
    attempt_array = attempt_array.chars
    # check if arrays 'grid' and 'attempt_array' match for every letter
    # include?
    # makes an array with true/false values
    attempt_array.map! do |attempt_character|
      grid.include?(attempt_character)
    end
    # if every letter of 'attempt' appears in 'grid' -> every_letter == true
    # if all values are true, every_letter = true
    # if .include? is true for all letters of attempt -> every_letter == true
    attempt_array.all? ? every_letter = true : every_letter = false
    return_hash = {}

    # player can only use each letter once in the attempt


    # if the 'attempt' is not valid or not in the grid - score 0

    # score depends on the time to answer + length of submitted word

    # add 'time' to 'return_hash'
    return_hash[:time] = time

    ##### compute the score based on 'time' and length of 'attempt'
    score = 200
    # per letter +ten score
    score += 10 * attempt.length
    # per second -ten score
    score -= 10 * time
    # add score to 'return_hash'
    return_hash[:score] = score

    #### make a score
    if word_english == false
      score = 0
      return_hash[:score] = score
    end

    #### make a custom message
    #   the given word is not an english one
    #   the given word is not in the grid
    #   the given word has the correct letters but some letters are overused

    # standard custom message
    custom_message = "well done"

    # if 'word_english' is false, compute custom message
    if word_english
      nil
    else
      custom_message = "your word: #{attempt} is not an english word"
    end

    # build custom message if word is not in the grid
    if every_letter
      nil
    else
      custom_message = "word #{attempt} not in the grid"
      score = 0
      return_hash[:score] = score
    end


    # if 'attempt' overuses letters, return "word #{attempt} not in the grid"
    # make alphabet array
    alphabet_array = ("A".."Z").to_a

    # count the alphabet in the 'attempt_array' .count
    alphabet_array.each do |letter|
      attempt_array.count(letter)
    end
    # count the alphabet in the 'grid'    .count

    # compare the amounts each letter appears
    # -> if it appears more in attempt, 'custom_message' = "it's not in the grid"





    # add 'custom_message' to 'return_hash'
    return_hash[:message] = custom_message

    # return 'return_hash'
    return_hash
  end
end
