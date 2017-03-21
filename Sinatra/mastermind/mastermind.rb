class Game
  def initialize
    @number_of_turns = 0
    @code_size = 0
  end

    def begin
    setup_players
    @maker.generate_code
    until @number_of_turns == @code_size * 4 || @breaker.guess == @maker.code
      @breaker.try_to_guess(@maker.feedback)
      @maker.give_feedback(@breaker.guess)
      @number_of_turns += 1
    end
    finish_game
  end
  
  def setup_players
    puts "Enter the code size you want to play:"
    @code_size = gets.chomp.to_i
    if @code_size < 1
      puts "Enter the code size you want to play:"
      @code_size = gets.chomp.to_i
    end
    puts "Do you want to play with letters or number?"
    puts "--l-- for letters."
    puts "--n-- for numbers."
    patern = gets.chomp.downcase
    if patern == "l"
      @patern = patern
    elsif patern == "n"
      @patern = patern
    else
      puts "You must select between letters or number?"
      puts "--l-- for letters."
      puts "--n-- for numbers."
      patern = gets.chomp.downcase
    end
    puts 'Do you want to (M)ake or (B)reak the code?'
    answer = gets.chomp
    if answer.downcase == 'm'
      @maker = Human.new(@code_size, @patern)
      @breaker = Computer.new(@code_size, @patern)
    elsif answer.downcase == 'b'
      @breaker = Human.new(@code_size, @patern)
      @maker = Computer.new(@code_size, @patern)
    else
      puts "I didn't understand that, please try again."
      setup_players
    end
  end

  def finish_game
    if @breaker.guess == @maker.code
      puts "Correct! The code was broken in #{@number_of_turns} turns!"
      puts 'Codebreaker wins!'
    else
      puts 'Game over, Codebreaker failed to break the code!'
      puts "The correct answer was #{@maker.code}."
      puts 'Codemaker wins!'
    end
  end
end

class Computer
  attr_accessor :guess, :code, :sample, :feedback

  def initialize(code_size, patern)
    @code_size = code_size
    @guess = ''
    @code = ''
    @feedback = Array.new(@code_size)
    if patern == "l"
      @sample = *("A".."Z")
    else
      @sample = *("0".."9")
    end
  end

  def generate_code
    puts 'Welcome to Mastermind!'
    @code_size.times do
      @code += @sample.sample
    end
    puts "The secret code is a number containing #{@code_size} chars from #{@sample.first} to #{@sample.last}."
    puts 'The computer will give you feedback on your guess:'
    puts "'$' means a correct number in the correct position."
    puts "'*' means a correct number, but in the wrong position."
    puts "'?' means that this number is not in the code."
  end

  def give_feedback(guess)
    @feedback = []
    temp_code = @code.upcase.chars
    guess.chars.map.each_with_index do |val, ind|
      if val == temp_code[ind]
        @feedback << '$'
        temp_code[ind] = 'X'
      elsif temp_code.include?(val)
        @feedback << '*'
        temp_code[temp_code.index(val)] = 'X'
      else
        @feedback << '?'
      end
    end
    puts "Your beedback: #{@feedback.join}"
  end

  def try_to_guess(feedback = Array.new(@code_size, 'x'))
    feedback.each_with_index do |val, ind|
      if val == '$'
        next
      elsif val == '?' && !feedback.include?('*')
        @sample.delete(@guess[ind])
        @guess[ind] = @sample.sample
      else
        @guess[ind] = @sample.sample
      end
    end
    puts "The computer guesses #{@guess}."
  end
end

class Human
  attr_accessor :code, :guess, :feedback

  def initialize(code_size, patern)
    @code_size = code_size
    @guess = ''
    @code = ''
    @feedback = Array.new(@code_size, 'x')
    if patern == "l"
      @sample = *("A".."Z")
    else
      @sample = *("0".."9")
    end
  end

  def generate_code
    puts 'Create a code and see if the computer can break it!'
    puts "The code is a patern containing #{@code_size} chars, each between #{@sample.first} to #{@sample.last}."
    input = gets.chomp
    if input.split('').each { |i| i.between?(@sample.first, @sample.last) } && input.size == @code_size
      @code = input
    else
      puts 'This is not a valid code, try again!'
      generate_code
    end
  end

  def try_to_guess(*)
    puts 'Try to guess the code!:'
    input = gets.chomp.upcase
    if input.size == @code_size && input.split('').each { |d| d.between?(@sample.first, @sample.last) }
      @guess = input
    else
      puts 'This is not a valid guess, try again!'
      try_to_guess
    end
  end

  def give_feedback(guess)
    @feedback = []
    temp_code = @code.upcase.chars
    guess.chars.map.each_with_index do |val, ind|
      if val == temp_code[ind]
        @feedback << '$'
        temp_code[ind] = 'X'
      elsif temp_code.include?(val)
        @feedback << '*'
      else
        @feedback << '?'
      end
    end
    puts "The computer gets feedback: #{@feedback.join}"
  end
end

Game.new.begin