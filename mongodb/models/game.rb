class Game
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :sha2
  field :technology
  field :width, type: Integer, default: 640
  field :height, type: Integer, default: 480
  field :size, type: Integer
  field :file_grid_id
  field :old_id, type: Integer
  
  has_many :infos, class_name: 'GameInfo', dependent: :destroy
  
  before_destroy :delete_file
  
  def put_file_from file
    GridFS.put(b, {filename: sha2 + '.' + format, content_type: MIME_TYPES[format.to_sym]})
  end
  
  def get_grid_file
    GridFS.get file_grid_id
  end
  
  def path
    GAMES_PATH + sha2
  end
    
  def set_file path_to_file
    self.sha2 = Digest::SHA2.file(path_to_file).hexdigest
    FileUtils.copy path_to_file, path
    self.technology = path_to_file[-3..-1].downcase unless technology
    get_swf_size(path_to_file) if technology == 'swf'
  end
  
  def delete_file
    FileUtils.remove path
  end
  
  def get_swf_size path_to_file
    require 'imagespec/image_spec.rb'
    swf_file = ImageSpec.new path
    self.width = swf_file.width
    self.height = swf_file.height
  end
  
end
