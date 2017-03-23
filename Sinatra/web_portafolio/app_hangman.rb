class Hangman
  attr_accessor :progress, :word_to_guess, :misses
  def initialize
    @misses = []
    @guess = ''
    @progress = []
    @guessed_letters = []
    @dictionary = []
    new_word
  end
    
  def new_word
    File.open('5desk.txt', 'r').readlines.each do |line|
      @dictionary.push(line) if line.strip.length.between?(5, 12)
    end
    @word_to_guess = @dictionary.sample.strip.downcase.split('')
  end
  
  def check_guess(guess)
    if @misses.include?(guess) ||  @progress.include?(guess)
      @message =  "You already tried that letter!!"
    elsif ("a".."z").cover?(guess)
      @guess = guess
      check_progress
    else
      @message = "Use single letters from a to z."
    end
  end
  
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
    message_game
  end
  
  def message_game
    if @progress == @word_to_guess
      @message = "You guessed it, the word was #{@word_to_guess.join.upcase}! You win! Another word was generated."
    elsif @misses.length > 5
      @message = "Out of turns! The correct word was #{@word_to_guess.join("").upcase}! You lose! Another word was generated."
    else
      @message = "You have #{6 - @misses.length} missed guesses left."
    end
  end
  
  def imagen
    @imagen = case
    when @misses.size == 1 then '<img src="http://i27.tinypic.com/2i6cm5k.png" alt="hangman" height="100" width="70">'
    when @misses.size == 2 then '<img src="http://i30.tinypic.com/2dhtuuf.png" alt="hangman" height="100" width="70">'
    when @misses.size == 3 then '<img src="http://i26.tinypic.com/21bj59u.png" alt="hangman" height="100" width="70">'
    when @misses.size == 4 then '<img src="http://i27.tinypic.com/10yp18p.png" alt="hangman" height="100" width="70">'
    when @misses.size == 5 then '<img src="http://i29.tinypic.com/1zvsrjd.png" alt="hangman" height="100" width="70">'
    when @misses.size == 6 then '<img src="http://i31.tinypic.com/s4ugra.png" alt="hangman" height="100" width="70">'
    else
      ""
    end
  end
end

