require "spec_helper"

describe Game do
  before :each do
    @game = Game.new :sha2 => 'asp123', :technology => 'swf'
  end
  subject { @game }
  it { should respond_to :sha2 }
  it { should respond_to :technology }
  it { @game.sha2.should == 'asp123'}
  it { @game.technology.should == 'swf'}
end