require "./lib/grid.rb"
# grid should
# hold info about current grid !
# print current grid !
# assign state to certain squares !
# apply player step to itself !
# check if game is over
# return winner

describe Grid do
  before(:each) do
    @grid = Grid.new
  end

  describe "#to_s" do
    it "prints empty grid" do
      expect(@grid.to_s).to eq(
        <<~EOS
        1#{" "*14}
        2#{" "*14}
        3#{" "*14}
        4#{" "*14}
        5#{" "*14}
        6#{" "*14}
          1 2 3 4 5 6 7
        EOS
      )
    end

    it "prints full grid" do
      symbols = [:x, :o]
      7.times do |column_index|
        3.times { @grid.put_to_column(column_index + 1, symbols[0]) }
        3.times { @grid.put_to_column(column_index + 1, symbols[1]) }
        symbols.reverse!
      end

      expect(@grid.to_s).to eq(
        <<~EOS
        1 o x o x o x o
        2 o x o x o x o
        3 o x o x o x o
        4 x o x o x o x
        5 x o x o x o x
        6 x o x o x o x
          1 2 3 4 5 6 7
        EOS
      )
    end
  end

  describe "#put_to_column" do
    it "puts symbols correctly to grid" do
      @grid.put_to_column(2, :x)
      @grid.put_to_column(2, :x)
      @grid.put_to_column(1, :o)
      expect(@grid.to_s).to eq(
        <<~EOS
        1#{" "*14}
        2#{" "*14}
        3#{" "*14}
        4#{" "*14}
        5   x#{" "*10}
        6 o x#{" "*10}
          1 2 3 4 5 6 7
        EOS
      )
    end

    it "raises error when the column is filled" do
      6.times { @grid.put_to_column(1, :x) }
      expect { @grid.put_to_column(1, :x) }.to raise_error("Full column")
    end
  end

  describe "#winner" do
    it "returns nil if there's no winner yet" do
      expect(@grid.winner).to be_nil
    end

    it "recognizes a draw" do
      symbols = [:x, :o]
      7.times do |column_index|
        3.times { @grid.put_to_column(column_index + 1, symbols[0]) }
        3.times { @grid.put_to_column(column_index + 1, symbols[1]) }
        symbols.reverse!
      end

      expect(@grid.winner).to eq(:draw)
    end

    it "works with columns" do
      @grid.put_to_column(2, :x)
      4.times { @grid.put_to_column(2, :o) }
      expect(@grid.winner).to eq(:o)
    end
  end
end
