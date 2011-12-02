require "spec_helper"

describe Rating do
  before :each do
    @valid_attributes = {ip: '192.168.3.1', website_id: 2, spec_id: 7, love: true}
    @rating = Rating.new @valid_attributes
  end
  subject { @rating }
  it { should respond_to :ip }
  it { should respond_to :website_id }
  it { should respond_to :spec_id }
  it { should respond_to :love }
  it { should be_valid }
  context "Invalid ip" do
    before { @rating.ip = '192.168. - 3.1'}
    it { should_not be_valid }
  end
  context "Invalid spec_id" do
    before { @rating.spec_id = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid website_id" do
    before { @rating.website_id = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid love" do
    before { @rating.love = nil }
    it { should_not be_valid }
  end
  context "Double Voting not allowed" do
    before do 
      @rating.save
      @same_rating = Rating.new @valid_attributes 
    end
    subject { @same_rating }
    it { should_not be_valid }
  end
  context "Double Voting with diff. ip is allowed" do
    before do 
      @same_rating = Rating.new @valid_attributes.merge(:ip => '192.168.3.2')
    end
    subject { @same_rating }
    it { should be_valid }
  end
end