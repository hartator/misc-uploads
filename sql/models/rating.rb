class Rating < ActiveRecord::Base
  
  belongs_to :spec
  belongs_to :website
  
  scope :sort_by_updated, :order => 'updated_at DESC'
  scope :website, lambda {|website| where(:website_id => website.id)}
  
  validates :ip, :presence => true
  validates :ip, :format => /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/
  validates :ip, :length => {:maximum => 15, :minimum => 7}
  validates :ip, :uniqueness => {:scope => [:spec_id, :website_id]}
  validates :website_id, :presence => true, :numericality => true
  validates :spec_id, :presence => true, :numericality => true
  validates :love, :inclusion => {:in => [true, false]}
  
end
