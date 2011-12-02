# encoding: UTF-8

require "spec_helper"

describe GameInfo do
  before :all do
    @info = GameInfo.new
    @game = Gamem.create
  end
  subject { @info }
  context "Sample Info" do
    before :all do
      @info.attributes = {
        title: "Beautifull Games (Très)", 
        description: "Play a lot with this game (Très)", 
        manual: "Use a lot with this game (Très)", 
        notes: "A blablo (Très)", 
        categories: "Coursé", 
        meta_keywords: "Coucou, Boubou",
        website: "defouland.com", 
        url: "http://www.defouland.com",
        screenshot: "screenshot", 
        screenshot_type: "png", 
        rate: 9, 
        width: 640, 
        height: 480, 
        old_id: 32, 
        old_game_id: 9
      }
    end
    it { @info.title.should == "Beautifull Games (Très)" }
    it { @info.width.should be 640 }
    it { @info.height.should be 480 }
    it { @info.save.should be true }
    it { GameInfo.where(_id: @info.id).to_a.should == [@info] }
    it { @info.keywords.should == ["beautifull", "games", "tres", "play", "a", "lot", "with", "this", "game", "use", "blablo", "course", "coucou", "boubou", "defouland", "com"] }
  end
  context "Sample Game" do
    before :all do
      @info.game = @game
    end
    it { @info.game.should == @game }
    it { @info.save.should be true }
    it { Gamem.where(_id: @game.id).to_a.should == [@game] }
  end
  context "Destroy Info" do
    it { @info.destroy.should be true }
    it { GameInfo.where(_id: @info.id).to_a.should == [] }
    it { Gamem.where(_id: @game.id).to_a.should == [@game] }
  end
end