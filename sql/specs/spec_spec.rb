require "spec_helper"

describe Spec do
  before :each do
    @spec = Spec.new game_id: 4, category_id: 2
  end
  subject { @spec }
  it { should respond_to :game_id }
  it { should respond_to :category_id }
  it { should be_valid }
  context "Invalid game_id should not be valid" do
    before { @spec.game_id = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid category_id should not be valid" do
    before { @spec.category_id = 'asap'}
    it { should_not be_valid }
  end
end