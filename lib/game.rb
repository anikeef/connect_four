require "./lib/grid.rb"

class Game
  Player = Struct.new(:symbol, :name)
  class IncorrectInput < StandardError; end

  def initialize
    print "X player's name: "
    name1 = gets.chomp
    print "O player's name: "
    name2 = gets.chomp
    @players = [Player.new(:x, name1), Player.new(:o, name2)]
    @grid = Grid.new
  end

  def play
    puts @grid.to_s
    players = @players.cycle
    until (winner_symbol = @grid.winner)
      player = players.next
      begin
        print "#{player.name}'s step (e.g. 1): "
        column = gets.chomp
        raise IncorrectInput unless /\A\d\Z/.match?(column)
        @grid.put_to_column(column.to_i, player.symbol)
      rescue IncorrectInput
        puts "Incorrect input, try again"
        retry
      rescue FullColumn
        puts "Full column, choose another"
        retry
      end
      puts @grid.to_s
    end
    game_over(winner_symbol)
  end

  def game_over(symbol)
    if symbol == :draw
      puts "It's a draw!"
    else
      winner = @players.find { |player| player.symbol == symbol }
      puts "#{winner.name}'s win!"
    end
  end
end
