require "yaml"

class Game
  def initialize
    @misses = []
    @guess = ''
    @progress = []
    @guessed_letters = []
    @dictionary = []
    start_game
  end
  
  #Display a menu for the player to start, load or exit the game.
  def start_game
    puts %{Welcome to HANGMAN!!
      What do you want to do?
        --N-- Start a new game.
        --L-- Load a saved game.
        --E-- Exit from game.}
    choice = gets.chomp.downcase
    case choice
    when 'n' then new_game
    when 'l' then load_game
    when 'e' then exit
    else 
      puts "I didn't understand, try again!"
      start_game
    end
  end
  
  def new_game
    #We read the dictionary file:
    File.open('5desk.txt', 'r').readlines.each do |line|
      @dictionary.push(line) if line.strip.length.between?(5, 12)
    end
    #We pick a random word:
    @word_to_guess = @dictionary.sample.strip.downcase.split('')
    guess_letter
  end
  
  #Guess a letter:
  def guess_letter
    puts %{Guess a letter, Save your game or Exit the game!!
      --Any letter-- Guess a letter.
      --1-- Save the game.
      --0-- Exit the game.}  
    choise = gets.chomp.downcase
    case choise
    when '1' then save_game
    when '0' then exit
    else
      check_guess(choise)
    end
  end
  
  def check_guess(guess)
    if @misses.include?(guess) ||  @progress.include?(guess)
      puts "You already tried that letter!!"
      guess_letter
    elsif ("a".."z").cover?(guess)
      @guess = guess
      check_progress
    else
      puts "That is not a valid guess! Use single letters from a to z."
      guess_letter
    end
  end
  
  #We check the pregress:
  def check_progress
    @progress = []
    @word_to_guess.each do |letter|
      if @guess == letter || @guessed_letters.include?(letter)
        @progress.push(letter)
      else
        @progress.push("-")
      end
    end
    if @word_to_guess.include?(@guess)
      @guessed_letters << @guess
    else
      @misses << @guess
    end
    
    puts "You have guessed: #{@progress.join('').upcase}"
    puts "Your misses: #{@misses.join("-").upcase}"
    puts "You have #{11 - @misses.length} missed guesses left."
    finish_game
    guess_letter
  end
  
  #Out of turns! The correct word was #{@word.join.upcase}!
  def finish_game
    if @progress == @word_to_guess
      puts "You guessed it, the word was #{@word_to_guess.join.upcase}! You win!"
      puts 'Thanks for playing, goodbye!'
      exit
    elsif @misses.length > 10
      puts "Out of turns! The correct word was #{@word_to_guess.join("").upcase}! You lose!"
      puts 'Thanks for playing, goodbye!'
      exit
    end
  end
  
  #Save the game: 
  #Serializes the game object to a file with the chosen name.
  def save_game
    puts "Enter a name for your saved game:"
    name = gets.chomp
    if Dir.exists?("saves")
       File.open("saves/#{name}.sv", 'w') {|file| file.write(YAML::dump(self))}
      puts "Game saved!"
    else
      Dir.mkdir("saves")
       File.open("saves/#{name}.sv", 'w') {|file| file.write(YAML::dump(self))}
      puts "Game saved!"
    end
    
  end
  
  #Takes a name of a saved game object as an argument and loads the object.
  def load_game
    puts 'Please type the name of your game:'
    name = gets.chomp
    if File.exists?("saves/#{name}.sv")
      YAML::load(File.open("saves/#{name}.sv")).check_progress
    elsif Dir.glob('saves/*').empty?
      puts 'No saved games found!'
      start_game
    else
      puts 'Found the following saves:'
      puts Dir.glob('saves/*').join("\n")
      start_game
    end
  end
  
end

Game.new
