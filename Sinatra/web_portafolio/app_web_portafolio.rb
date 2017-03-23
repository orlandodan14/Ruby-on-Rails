require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack'
require_relative 'app_web_guesser.rb'
require_relative 'app_caesar_cipher.rb'
require_relative 'app_hangman.rb'
require_relative 'app_mastermind.rb'

use Rack::Session::Pool, :expire_after => 2592000

#Portafolio
get '/' do
  erb :index  
end

#Web_guesser
get '/web_guesser.erb' do  
  guess = params["guess"].to_i
  cheat = cheat_mode(params[:cheat])
  message = check_guess(guess)
  color = color(guess)
  erb :web_guesser, :locals => {:message => message, :color => color, :cheat => cheat }
end

#Caesar_cipher
get '/caesar_cipher.erb' do
  string = params['string'].to_s
  num = params['num'].to_i
  answer = cipher(string, num)
  erb :caesar_cipher, :locals => {:answer => answer}
end

#Hangman
helpers do
  def set_game
    session[:game] = Hangman.new
  end
end

get '/hangman.erb' do  
  set_game if session[:game].nil?
  if session[:game].class == Mastermind
    set_game
  end
  if params[:game] == "New" ||
    session[:game].progress == session[:game].word_to_guess ||
    session[:game].misses.length > 5
    set_game
  end
  
  guess = params[:guess]
  message = session[:game].check_guess(guess)
  progress = session[:game].progress.join(' ').upcase
  misses = session[:game].misses.join(', ').upcase
  imagen = session[:game].imagen
  
  erb :hangman, :locals => {:message => message, :progress => progress, :misses => misses, :imagen => imagen}
end

#Masterming
helpers do
  def set_game1
    session[:game] = Mastermind.new
  end
end

get '/mastermind.erb' do
  set_game1 if session[:game].nil?
  if session[:game].class == Hangman
    set_game1
  end
  if params[:game] == "New" ||
    session[:game].feedback == ["\u2611".encode('utf-8'), "\u2611".encode('utf-8'), "\u2611".encode('utf-8'), "\u2611".encode('utf-8')] ||
    session[:game].number_of_turns == 0
    set_game1
  end
  
  guess = params[:code]
  message = session[:game].message(guess)
  feedback = session[:game].feedback.join(' ')
  turns = session[:game].number_of_turns
  path = session[:game].feedback_path
  guesses = session[:game].guesses
  code = session[:game].code
  
  erb :mastermind, :locals => {:message => message, :feedback => feedback, :turns => turns, :path => path, :guesses => guesses}
end

