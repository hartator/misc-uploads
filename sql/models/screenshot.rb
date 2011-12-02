class Screenshot < ActiveRecord::Base
  belongs_to :screenshotable, :polymorphic => true
  
  validates :sha2, :format, :presence => true
  validates :width, :height, :presence => true, :numericality => true
  validates :screenshotable_type, :presence => true
  
  after_create :tempfile_saving, :destroy_previous_if_original
  after_destroy :delete_file
  
  def delete_file
    FileUtils.remove(path) if Screenshot.find_by_sha2(sha2).nil?
  end
  
  def destroy_previous_if_original
    if original == true
      screenshotable.screenshots.each do |screenshot|
        screenshot.destroy unless screenshot.id == id
      end
    end
  end
  
  def upload= uploaded
    sha2 = Screenshot.file_sha2(uploaded.tempfile)
    extension = uploaded.original_filename[-3..-1].downcase
    image = MiniMagick::Image.open(uploaded.tempfile.path)
    self.sha2 = sha2
    self.original = true
    self.format = extension
    self.width = image[:width]
    self.height = image[:height]
    @tempfile = uploaded.tempfile
  end
  
  def create_thumb original, destination
    thumb_file = original.generate_thumb(destination)
    thumb_sha2 = Screenshot.file_sha2(thumb_file.path)
    self.sha2 = thumb_sha2
    self.original = false
    self.format = destination[:format]
    self.width = destination[:width]
    self.height = destination[:height]
    @tempfile = thumb_file
  end
  
  def generate_thumb destination
    image = MiniMagick::Image.open(path)
    image.format destination[:format]
    image.combine_options do |c|
      c.resize "#{destination[:width]}x#{destination[:height]}!"
      c.quality '92'
    end
    image
  end 
  
  def file= file
    extension = file[-3..-1].downcase
    image = MiniMagick::Image.open(file)
    self.sha2 = Screenshot.file_sha2(file)
    self.original = true
    self.format = extension
    self.width = image[:width]
    self.height = image[:height]
    @tempfile = File.open(file)
  end
  
  def path
    SCREENSHOTS_PATH + sha2
  end
  
  def tempfile_saving
    FileUtils.copy(@tempfile.path, SCREENSHOTS_PATH + sha2)
  end
  
  def self.file_sha2 source_file
    Digest::SHA2.file(source_file).hexdigest
  end
  
end
