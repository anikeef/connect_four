require "./lib/game.rb"

describe Game do
  before :each do
    $stdout = StringIO.new
  end

  describe "#initialize" do
    it "stores the usernames" do
      allow_any_instance_of(Game).to receive(:gets).and_return("Gena", "Tayga")
      game = Game.new
      players = game.instance_variable_get(:@players)
      expect(players[0].name).to eq("Gena")
      expect(players[1].name).to eq("Tayga")
    end

    it "holds the empty grid" do
      allow_any_instance_of(Game).to receive(:gets).and_return("Gena", "Tayga")
      expect(Game.new.instance_variable_get(:@grid)).to be_a(Grid)
    end
  end

  describe "#play" do
    it "outputs the first player's name if he wins" do
      allow_any_instance_of(Game).to receive(:gets).and_return(
        "Gena", "Tayga", "1", "7", "2", "6", "3", "5", "4"
      )
      expect { Game.new.play }.to output(/Gena's win!$/).to_stdout
    end

    it "outputs the second player's name if he wins" do
      allow_any_instance_of(Game).to receive(:gets).and_return(
        "Gena", "Tayga", "1", "7", "2", "7", "3", "7", "5", "7"
      )
      expect { Game.new.play }.to output(/Tayga's win!$/).to_stdout
    end

    it "outputs a draw message" do
      allow_any_instance_of(Game).to receive(:gets).and_return(
        "Gena", "Tayga",
        "1", "2", "1", "2", "1", "2",
        "2", "1", "2", "1", "2", "1",
        "3", "4", "3", "4", "3", "4",
        "4", "3", "4", "3", "4", "3",
        "5", "6", "5", "6", "5", "6",
        "7", "5", "7", "5", "7", "5",
        "6", "7", "6", "7", "6", "7"
      )
      expect { Game.new.play }.to output(/It's a draw!$/).to_stdout
    end

    it "works with incorrect inputs" do
      allow_any_instance_of(Game).to receive(:gets).and_return(
        "Gena", "Tayga", "1", "abc", "7", "2", "23", "b2", "6", "3", "5", "4"
      )
      expect { Game.new.play }.to output(/Gena's win!$/).to_stdout
    end

    it "works with full columns" do
      allow_any_instance_of(Game).to receive(:gets).and_return(
        "Gena", "Tayga", "1", "1", "1", "1", "1", "1", "1", "1", "1",
        "2", "7", "3", "7", "4"
      )
      expect { Game.new.play }.to output(/Gena's win!$/).to_stdout
    end
  end
end
