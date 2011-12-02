require "spec_helper"

describe Website do
  context "new with valid attributes" do
    website = Website.new(:slug => 'www.example.com', :cluster_id => Cluster.first.id, :locale => 'fr')
    it "should have a slug" do
      website.slug.should == 'www.example.com'
    end
    it "should have a cluster_id" do
      website.cluster_id.should == Cluster.first.id
    end
    it "should have a locale" do
      website.locale.should == 'fr'
    end
    it "should be valid" do
      website.should be_valid
    end
  end
  it "invalid slug should not be valid" do
    website = Website.new(:slug => 'www.exampl e.com', :cluster_id => Cluster.first.id, :locale => 'fr')
    website.should_not be_valid
  end
  it "invalid cluster id should not be valid" do
    website = Website.new(:slug => 'www.example.com', :cluster_id => 'asap', :locale => 'fr')
    website.should_not be_valid
  end
  it "invalid locale should not be valid" do
    website = Website.new(:slug => 'www.example.com', :cluster_id => Cluster.first.id, :locale => 'f r')
    website.should_not be_valid
  end
  it "double locale should not be valid" do
    website_attributes = Website.last.attributes
    website_attributes.delete('id')
    website_attributes['slug'] = 'www.example.com'
    website = Website.new(website_attributes)
    website.should_not be_valid
  end
  it "double slug should not be valid" do
    website_attributes = Website.last.attributes
    website_attributes.delete('id')
    website_attributes['locale'] = 'asap'
    website = Website.new(website_attributes)
    website.should_not be_valid
  end
end