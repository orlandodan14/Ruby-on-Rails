require 'sinatra'
require 'sinatra/reloader'

@@number = 1 + rand(100)
@@counter = 5

def guess_message(guess) 
  if guess == 0
    message = " "
  elsif guess > @@number && guess <= @@number + 5 
    message1 = "Too high! You have #{@@counter} guesses left."
  elsif guess < @@number && guess >= @@number - 5
    message = "Too low! You have #{@@counter} guesses left."
  elsif guess > @@number + 5 
    message = "Way too high! You have #{@@counter} guesses left."
  elsif guess < @@number - 5
    message = "Way too low! You have #{@@counter} guesses left."
  elsif guess == @@number
    message = "You got it right with #{@@counter} guesses left! The SECRET NUMBER is #{@@number}"
  end
end

def check_guess(guess)
  if @@counter == 1
    @@counter = 5
    @@number = 1 + rand(100)
    message = "You're out of guesses and you've lost. A new number has been generated."
  else
    @@counter -= 1
    message = guess_message(guess)
  end
end


def color(guess)
  color = case
  when guess == 0 then "white"
  when guess == @@number then "green"
  when guess < @@number - 5 || guess > @@number + 5 then "red"
  when guess < @@number && guess >= @@number - 5 then "orange"
  when guess > @@number && guess <= @@number + 5 then "orange"
  end
end

def cheat_mode(cheat)
  cheat ? "The secret number is #{@@number}" : ""
end

get '/' do  
  guess = params["guess"].to_i
  cheat = cheat_mode(params[:cheat])
  message = check_guess(guess)
  color = color(guess)
  erb :index, :locals => {:message => message, :color => color, :cheat => cheat }
end
