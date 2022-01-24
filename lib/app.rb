class Game
  def initialize(word)
    @secret_word = word
    @guess_array = []
    @incorrect_array = []
    @hang_count = 0
    @victory = false
    play
  end

  def play
    puts @secret_word
    @chars = @secret_word.split('')
    until @hang_count > 8 || @victory
      draw_game
      turn
    end
  end

  def draw_game
    temp_int = 0
    @chars.each do |letter|
      if @guess_array.to_s.include? letter
        print " _#{letter}_"
        temp_int += 1
      else
        print ' ___'
      end
    end

    puts
    if temp_int == @secret_word.length - 1
      @victory = true
    end
  end

  def turn
    puts "Please enter a letter to guess or type \"save\" to save your game.\n The incorrect letters you have entered so far are #{@incorrect_array}"
    letter_guess = gets.chomp.downcase
    @guess_array.push(letter_guess)
    if @secret_word.include? letter_guess
      puts 'Correct!'
    else
      @incorrect_array.push(letter_guess)
      @hang_count += 1
    end
  end
end

if File.exist? '5desk.txt'
  lines = File.readlines('5desk.txt')
else
  puts 'Error: No dictionary file found.'
end

dictionary_array = []

lines.each do |line|
  if line.length > 5 && line.length < 12
    dictionary_array << line.downcase.strip
  end
end

Game.new(dictionary_array[rand(dictionary_array.length)])