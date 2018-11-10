class FullColumn < StandardError; end

class Grid
  Square = Struct.new(:state)

  def initialize
    @filled_squares = 0
    @strings = Array.new(6) { Array.new(7) {Square.new} }
    @columns = @strings.transpose

    @diagonals = []
    [3,4,5].each do |n|
      @diagonals << (0..n).map { |i| @strings[5-n+i][i] }
      @diagonals << (0..n).map { |i| @strings[i][6-n+i] }
      @diagonals << (0..n).map { |i| @strings[5-n+i][6-i] }
      @diagonals << (0..n).map { |i| @strings[i][n-i] }
    end
  end

  def to_s
    @strings.map.with_index(1) do |string, index|
      "#{index}#{string.map { |square| " #{square.state.nil? ? " " : square.state.to_s}" }.join}\n"
    end.join.concat("  1 2 3 4 5 6 7\n")
  end

  def put_to_column(column_index, symbol)
    column = @columns[column_index - 1]
    raise FullColumn if column.first.state != nil
    column.reverse_each do |square|
      if square.state.nil?
        square.state = symbol
        @filled_squares += 1
        break
      end
    end
  end

  def winner
    winner =
      find_winner_in(@columns) ||
      find_winner_in(@strings) ||
      find_winner_in(@diagonals)

    if winner
      return winner
    elsif @filled_squares == 42
      return :draw
    else
      nil
    end
  end

  def find_winner_in(lines)
    lines.each do |line|
      winner = find_4_in_line(line)
      return winner if winner
    end
    nil
  end

  def find_4_in_line(line)
    count = 1
    line.inject do |previous, current|
      if previous.state && previous.state == current.state
        count += 1
        return current.state if count == 4
      else
        count = 1
      end
      current
    end
    nil
  end
end
