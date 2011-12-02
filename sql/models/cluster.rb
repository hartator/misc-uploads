class Cluster < ActiveRecord::Base
  
  has_many :websites, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :specs, :through => :categories
 
  validates :name, :presence => true, :format => /\A[a-z0-9]+\z/
  validates :name, :uniqueness => true
  
  def websites_by_lang_name
    websites.sort_by do |website|
      I18n.t(:lang_name, :locale => website.locale)
    end
  end
  
end
