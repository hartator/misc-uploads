class Tag < ActiveRecord::Base
  
    belongs_to :taggable, :polymorphic => true
    belongs_to :category
    
    validates :category_id, :presence => true, :numericality => true
    validates :taggable_id, :presence => true, :numericality => true
    validates :taggable_type, :presence => true
    
end
