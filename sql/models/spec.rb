class Spec < ActiveRecord::Base
  
  has_many :screenshots, :as => :screenshotable, :dependent => :destroy, :extend => ScreenshotsExtension
  has_many :tags, :as => :taggable, :dependent => :destroy
  has_many :categories, :through => :tags, :dependent => :destroy
  has_many :texts, :as => :textable, :dependent => :destroy, :extend => TextsExtension
  has_many :ratings, :dependent => :destroy
  
  belongs_to :category
  belongs_to :game
  
  delegate :cluster, :to => :category
  
  accepts_nested_attributes_for :screenshots, :categories, :texts, :allow_destroy => true
  
  validates :game_id, :presence => true, :numericality => true
  validates :category_id, :presence => true, :numericality => true
  validate :game_uniqueness_by_cluster
  validate :category_or_tag
  
  scope :cluster, lambda {|cluster| joins(:category).where('categories.cluster_id' => cluster.id)}
  scope :website, lambda {|website| joins(:texts).where('texts.website_id' => website.id)}
  
  def website website
    texts.where(:website_id => website.id).first
  end
  
  def voters website
    ratings.where(:website_id => website.id).size
  end

  def lovers website
    ratings.where(:website_id => website.id, :love => true).size
  end
  
  def haters website
    ratings.where(:website_id => website.id, :love => false).size
  end
  
  def rating website
    voters(website) == 0 ? 0.5 : lovers(website).to_f/voters(website)
  end
  
  private 
  
    def game_uniqueness_by_cluster
      test_id = id.nil? ? 0 : id
      if category
        if Spec.cluster(category.cluster).where('specs.id != ?',test_id).where(:game_id => game_id).any?
          errors.add(:game, 'is not unique')
        end
      else
        errors.add(:category, 'is nil')
      end
    end

    def category_or_tag
      if categories.include?(category)
        errors.add(:game, 'cannot be in the same category and tag')
      end
    end
    
end
