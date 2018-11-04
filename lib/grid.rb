class Grid
  Square = Struct.new(:state)

  def initialize
    @grid_strings = Array.new(6) { Array.new(7) {Square.new(nil)} }
    @grid_columns = @grid_strings.transpose
    @filled_squares = 0
  end

  def to_s
    @grid_strings.map.with_index(1) do |string, index|
      "#{index}#{string.map { |square| " #{square.state.nil? ? " " : square.state.to_s}" }.join}\n"
    end.join.concat("  1 2 3 4 5 6 7\n")
  end

  def put_to_column(column_index, symbol)
    column = @grid_columns[column_index - 1]
    loop do
      square = column.pop
      raise "Full column" if square.nil?
      if square.state.nil?
        square.state = symbol
        @filled_squares += 1
        break
      end
    end
  end

  def winner
    return :draw if @filled_squares == 42
  end

  # def find_winner_line(lines)
  #   lines.find do |line|
  #     false if line.
  #   end
  # end
end
