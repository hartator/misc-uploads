require "spec_helper"

describe Gamem do
  before :all do
    @game = Gamem.new
    @info = GameInfo.new  
  end
  subject { @game }
  context "Default Size" do
    it { @game.width.should be 640 }
    it { @game.height.should be 480 }
  end
  context "Sample SWF" do
    before(:all) { @game.set_file "#{::Rails.root}/spec/models/misc/sample.swf"}
    it { @game.width.should be 600 }
    it { @game.height.should be 400 }
    it { @game.technology.should == 'swf' }
    it { FileUtils.compare_file("#{::Rails.root}/spec/models/misc/sample.swf", @game.path).should be true }
    it { @game.save.should be true }
    it { Gamem.where(_id: @game.id).to_a.should == [@game] }
  end
  context "Sample Info" do
    before :all do
      @game.infos << @info
    end
    it { @game.infos.should == [@info] }
    it { @game.save.should be true }
    it { GameInfo.where(_id: @info.id).to_a.should == [@info] }
  end
  context "Make Some Change" do
    before(:all) do
      @game.width = 300
      @game.height = 200
    end
    it { @game.save.should be true }
    it { @game.width.should be 300 }
    it { @game.height.should be 200 }
    it { @game.technology.should == 'swf' }
  end
  context "Destroy Game" do
    it { @game.destroy.should be true }
    it { File.exists?(@game.path).should be false }
    it { Gamem.where(_id: @game.id).to_a.should == [] }
    it { GameInfo.where(_id: @info.id).to_a.should == [] }
  end
end