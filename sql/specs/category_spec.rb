require "spec_helper"

describe Category do
  before :each do
    @category = Category.new cluster_id: Cluster.first.id
  end
  it "should be valid" do
    @category.should be_valid
  end
  it "should respond to cluster_id" do
    @category.cluster_id.should be Cluster.first.id
  end
  it "invalid cluster_id not be valid" do
    @category.cluster_id = 'asap'
    @category.should_not be_valid
  end
end