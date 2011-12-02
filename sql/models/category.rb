class Category < ActiveRecord::Base
  
  has_many :screenshots, :as => :screenshotable, :dependent => :destroy, :extend => ScreenshotsExtension
  has_many :tags, :as => :taggable, :dependent => :destroy
  has_many :categories, :through => :tags
  has_many :texts, :as => :textable, :dependent => :destroy, :extend => TextsExtension
  belongs_to :cluster
  has_many :specs, :dependent => :destroy

  accepts_nested_attributes_for :screenshots, :categories, :texts, :allow_destroy => true
  
  scope :cluster, lambda {|cluster| where(:cluster_id => cluster.id)}
  scope :website, lambda {|website| joins(:texts).where('texts.website_id' => website.id)}
  
  validates :cluster_id, :presence => true, :numericality => true
  
  def specs_random website
    specs_total(website).order("RANDOM()")
  end
  
  def specs_by_ratings website
    specs_total(website).select("specs.id, specs.category_id, specs.game_id, ((SELECT COUNT(*) FROM ratings WHERE(ratings.website_id = #{website.id} AND ratings.love = 't' AND ratings.spec_id = specs.id))/(SELECT COUNT(*) FROM ratings WHERE(ratings.website_id = #{website.id} AND ratings.spec_id = specs.id))) as spec_rating, (SELECT COUNT(*) FROM ratings WHERE(ratings.website_id = #{website.id} AND ratings.spec_id = specs.id)) as spec_rating_count").order('spec_rating DESC, spec_rating_count DESC')
  end
  
  def specs_total website
    Spec.joins(:texts).joins('LEFT OUTER JOIN "tags" ON "tags"."taggable_id" = "specs"."id" AND "tags"."taggable_type" = "Spec"').where('texts.website_id = ? AND (specs.category_id = ? OR tags.category_id = ?)', website.id, id, id)
  end
  
  def specs_tagged
    Spec.joins(:tags).where('tags.category_id' => id)
  end
  
  def website website
    texts.where(:website_id => website.id).first
  end
  
  def title_for website
    texts.get_for(website).title
  end
 
  def slug_for website
    texts.get_for(website).slug
  end 
  
end
