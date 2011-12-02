class Text < ActiveRecord::Base
  
  belongs_to :textable, :polymorphic => true
  belongs_to :website
  
  scope :website, lambda {|website| where(:website_id => website.id)}
  
  validates :title, :slug, :presence => true
  validates :slug, :format => /\A[a-z0-9\P{ASCII}-]*\z/u
  validates :slug, :uniqueness => {:scope => :website_id}
  validates :website_id, :presence => true, :numericality => true
  validates :textable_type, :presence => true
  
  def self.to_slug source_string
    string = source_string
    string = string.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').downcase.to_s
    string = (string.blank? or string.size < source_string.size) ? source_string.downcase : string
    to_delete = %w{- " ' % ! @ ` ? : & = ( ) [ ] < > . , $}
    to_delete.each do |del|
      string = string.gsub(del,' ')
    end
    string = string.strip.gsub(/\s+/,'-')
  end
    
end
