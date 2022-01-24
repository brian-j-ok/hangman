require 'json'

class Game
  def initialize(word)
    puts 'Hello Player, what is your name?'
    @player_name = gets.chomp
    @secret_word = word
    @guess_array = []
    @incorrect_array = []
    @hang_count = 0
    @victory = false
    load_game
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
    puts "Please enter a letter to guess or type \"save\" to save your game.\n 
    The incorrect letters you have entered so far are #{@incorrect_array}"
    letter_guess = gets.chomp.downcase
    if letter_guess == "save"
      save_game
    else
      @guess_array.push(letter_guess)
      if @secret_word.include? letter_guess
        puts 'Correct!'
      else
        @incorrect_array.push(letter_guess)
        @hang_count += 1
      end
    end
  end

  def save_game
    Dir.mkdir('save_games') unless Dir.exist? ('save_games')
    filename = "save_games/#{@player_name}.json"
    tempHash = {
      "player_name" => @player_name,
      "secret_word" => @secret_word,
      "guess_array" => @guess_array,
      "incorrect_array" => @incorrect_array,
      "hang_count" => @hang_count
    }
    File.open(filename, 'w') do |file|
      file.write(tempHash.to_json)
    end
  end

  def load_game
    filename = "save_games/#{@player_name}.json"
    if File.exist?(filename)
      tempHash = JSON.parse(File.read(filename))
      @secret_word = tempHash["secret_word"]
      @guess_array = tempHash["guess_array"]
      @incorrect_array = tempHash["incorrect_array"]
      @hang_count = tempHash["hang_count"]
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