class Game < ActiveRecord::Base
  
  has_many :infos, :dependent => :destroy
  has_one :head, :dependent => :destroy
  has_many :specs, :dependent => :destroy
   
  after_create :create_head
  before_destroy :delete_file
  
  def width
    (head.width.blank? || head.width.zero?) ? '640' : head.width
  end
  
  def height
    (head.width.blank? || head.width.zero?) ? '480' : head.height  
  end
  
  def title
    sha2
  end
  
  def file_path
    GAMES_PATH + sha2
  end
  
  def self.file_sha2 source_file
    Digest::SHA2.file(source_file).hexdigest
  end
  
  def self.file_copy source_file
    FileUtils.copy source_file, GAMES_PATH + file_sha2(source_file)
  end
  
  private
  
    def delete_file
      FileUtils.remove file_path
    end
    
end