class Head < ActiveRecord::Base
  
  belongs_to :game
  
  before_validation :set_default
  before_save :magik_fill
  
  validates :width, :height, :presence => true, :numericality => true
  
  def magik_fill
    self.size = File.new(game.file_path).size if size.blank?
    if (width.blank? or height.blank?) || (width.zero? or height.zero?)
      if game.technology == 'swf'
          require 'imagespec/image_spec.rb'
          file_swf = ImageSpec.new(game.file_path)
          logger.info "#{file_swf.width}x#{file_swf.height}"
          self.width = file_swf.width
          self.height = file_swf.height
      else
        fill_with_info
      end
    end
  end
  
  private
  
    def fill_with_info
      unless game.infos.empty?
        self.width = game.infos.first.width
        self.height = game.infos.first.height
      end
    end
    
    def set_default
      self.width = 0 if width.nil?
      self.height = 0 if height.nil?
    end
    
end