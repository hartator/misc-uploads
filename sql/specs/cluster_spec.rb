require "spec_helper"

describe Cluster do
  context "new with valid attributes" do
    cluster = Cluster.new(:name => 'bobi')
    it "should have a name" do
      cluster.name.should == 'bobi'
    end
    it "should be valid" do
      cluster.should be_valid
    end
  end
  context "new with invalid attributes" do
    cluster = Cluster.new(:name => '')
    it "should have a name" do
      cluster.name.should == ''
    end
    it "should not be valid" do
      cluster.should_not be_valid
    end
  end
end