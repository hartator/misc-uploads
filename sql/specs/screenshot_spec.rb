require "spec_helper"

describe Screenshot do
  before :each do
    @screenshot = Screenshot.new width: 640, height: 480, sha2: 'asf458', format:'gif', screenshotable_id: 4, screenshotable_type: 'Spec'
  end
  subject { @screenshot }
  it { should respond_to :width }
  it { should respond_to :height }
  it { should respond_to :sha2 }
  it { should respond_to :format }
  it { should respond_to :screenshotable_id }
  it { should respond_to :screenshotable_type }
  it { should be_valid }
  context "Invalid width should not be valid" do
    before { @screenshot.width = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid height should not be valid" do
    before { @screenshot.height = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid sha2 should not be valid" do
    before { @screenshot.sha2 = ''}
    it { should_not be_valid }
  end
  context "Invalid format should not be valid" do
    before { @screenshot.format = ''}
    it { should_not be_valid }
  end
  context "Invalid screenshotable_type should not be valid" do
    before { @screenshot.screenshotable_type = ''}
    it { should_not be_valid }
  end
end