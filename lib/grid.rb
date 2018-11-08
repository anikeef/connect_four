class Grid
  Square = Struct.new(:state)

  def initialize
    @grid_strings = Array.new(6) { Array.new(7) {Square.new} }
    @grid_columns = @grid_strings.transpose
    @filled_squares = 0
    # @diagonals =
    #   [(0..3).map { |i| @grid_strings[i+2][i] },
    #   (0..4).map { |i| @grid_strings[i+1][i] },
    #   (0..5).map { |i| @grid_strings[i][i] },
    #   (0..5).map { |i| @grid_strings[i][i+1] },
    #   (0..4).map { |i| @grid_strings[i][i+2] },
    #   (0..3).map { |i| @grid_strings[i][i+3] },
    #
    #   (0..3).map { |i| @grid_strings[i+2][6-i] },
    #   (0..4).map { |i| @grid_strings[i+1][6-i] },
    #   (0..5).map { |i| @grid_strings[i][6-i] },
    #   (0..5).map { |i| @grid_strings[i][5-i] },
    #   (0..4).map { |i| @grid_strings[i][4-i] },
    #   (0..3).map { |i| @grid_strings[i][3-i] }]

    @diagonals = []
      [3,4,5].each do |n|
        @diagonals << (0..n).map { |i| @grid_strings[5-n+i][i] }
        @diagonals << (0..n).map { |i| @grid_strings[i][6-n+i] }
        @diagonals << (0..n).map { |i| @grid_strings[5-n+i][6-i] }
        @diagonals << (0..n).map { |i| @grid_strings[i][n-i] }
      end
  end

  def to_s
    @grid_strings.map.with_index(1) do |string, index|
      "#{index}#{string.map { |square| " #{square.state.nil? ? " " : square.state.to_s}" }.join}\n"
    end.join.concat("  1 2 3 4 5 6 7\n")
  end

  def put_to_column(column_index, symbol)
    column = @grid_columns[column_index - 1]
    raise "Full column" if column.first.state != nil
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
      find_winner_in(@grid_columns) ||
      find_winner_in(@grid_strings) ||
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
