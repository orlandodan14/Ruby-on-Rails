require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack'

use Rack::Session::Pool, :expire_after => 2592000

class Game
  attr_accessor :number_of_turns, :guess, :code, :feedback, :pattern, :feedback_path, :code_size, :guesses
  def initialize
    @number_of_turns = 10
    @code_size = 4
    @guess = ''
    @code = ''
    @feedback = Array.new(@code_size)
    @pattern = *("0".."9")
    @feedback_path = []
    @guesses = []
    generate_code
  end
  
  def generate_code
    @code_size.times do
      @code << @pattern.sample
    end
    return @code
  end
  
  def give_feedback(guess)
    @number_of_turns -= 1
    @guesses.unshift(guess)
    @feedback = []
    temp_code = @code.upcase.chars
    guess.chars.map.each_with_index do |val, ind|
      if val == temp_code[ind]
        @feedback << "\u2611".encode('utf-8')
        temp_code[ind] = 'X'
      else
        if temp_code.include?(val)
          @feedback << "\u2612".encode('utf-8')
        end
      end
    end
    if @feedback.empty?
      @feedback << "\u2639".encode('utf-8')
    end
    @feedback_path.unshift(@feedback)
    finish_game(guess)
  end
  
  def message(guess)
    if guess.nil?
      @message = "Enter a 4 digits number, please!!"
    elsif guess.length != 4
      @message = "Enter a 4 digits number, please!!"
    elsif guess.split('').all? { |d| @pattern.include?(d) }
      give_feedback(guess)
    else
      @message = "Enter a 4 digits number, please!!"
    end
  end
  
  
  def finish_game(guess)
    if guess == @code
      @message = "You guessed it, the word was #{@code}! You win! Another code was generated."
    elsif @number_of_turns == 0
      @message = "Out of turns! The correct code was #{@code}! You lose! Another code was generated."
    end
  end
end


helpers do
  def set_game
    session[:game] = Game.new
  end
end


get '/' do
  set_game if session[:game].nil?
  if params[:game] == "New" ||
    session[:game].feedback == ["\u2611".encode('utf-8'), "\u2611".encode('utf-8'), "\u2611".encode('utf-8'), "\u2611".encode('utf-8')] ||
    session[:game].number_of_turns == 0
    set_game
  end
  
  guess = params[:code]
  message = session[:game].message(guess)
  feedback = session[:game].feedback.join(' ')
  turns = session[:game].number_of_turns
  path = session[:game].feedback_path
  guesses = session[:game].guesses
  code = session[:game].code
  
  erb :index, :locals => {:code => code, :message => message, :feedback => feedback, :turns => turns, :path => path, :guesses => guesses}
end
