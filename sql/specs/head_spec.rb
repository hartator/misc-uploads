require "spec_helper"

describe Head do
  before :each do
    @head = Head.new width: 640, height: 480, size: 640000, game_id:1
  end
  subject { @head }
  it { should respond_to :width }
  it { should respond_to :height }
  it { should respond_to :size }
  it { should respond_to :game_id }
  it { should be_valid }
  context "Invalid width should not be valid" do
    before { @head.width = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid height should not be valid" do
    before { @head.height = 'asap'}
    it { should_not be_valid }
  end
end