require "spec_helper"

describe Text do
  before :each do
    @valid_attributes = {title: 'Mad Games', description: 'A lot of mad Games.', slug: 'mad-games', website_id: 2, textable_id: 4, textable_type: 'Category'}
    @text = Text.new @valid_attributes
  end
  subject { @text }
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :slug }
  it { should respond_to :website_id }
  it { should respond_to :textable_id }
  it { should respond_to :textable_type }
  it { should be_valid }
  context "Invalid title should not be valid" do
    before { @text.title = ''}
    it { should_not be_valid }
  end
  context "Invalid slug should not be valid" do
    before { @text.slug = ''}
    it { should_not be_valid }
  end
  context "Invalid website_id should not be valid" do
    before { @text.website_id = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid textable_type should not be valid" do
    before { @text.textable_type = ''}
    it { should_not be_valid }
  end
  context "Double Slug should not be valid" do
    before do
      @text.save
      @text_doubled = Text.new @valid_attributes
    end
    subject { @text_doubled }
    it { should_not be_valid }
  end
  context "Different Slug should not be valid" do
    before do
      @text_doubled = Text.new @valid_attributes.merge(:slug => 'mad-game-2')
    end
    subject { @text_doubled }
    it { should be_valid }
  end
end