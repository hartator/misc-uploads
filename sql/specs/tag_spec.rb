require "spec_helper"

describe Tag do
  before :each do
    @tag = Tag.new category_id: 4, taggable_id: 2, taggable_type: 'Spec'
  end
  subject { @tag }
  it { should respond_to :category_id }
  it { should respond_to :taggable_id }
  it { should respond_to :taggable_type }
  it { should be_valid }
  context "Invalid category_id should not be valid" do
    before { @tag.category_id = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid taggable_id should not be valid" do
    before { @tag.taggable_id = 'asap'}
    it { should_not be_valid }
  end
  context "Invalid taggable_type should not be valid" do
    before { @tag.taggable_id = ''}
    it { should_not be_valid }
  end
end