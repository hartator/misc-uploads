class Website < ActiveRecord::Base
  
  belongs_to :cluster
  has_many :texts, :dependent => :destroy

  validates :slug, :presence => true, :format => /\A[a-zA-Z0-9\/\-\.]+\z/
  validates :slug, :uniqueness => true
  validates :cluster_id, :presence => true, :numericality => true
  validates :locale, :presence => true, :format => /\A[a-zA-Z0-9\-]+\z/
  validates :locale, :uniqueness => {:scope => :cluster_id}
  
  def specs_by_ratings
    specs_total.select("specs.id, specs.category_id, specs.game_id, ((SELECT COUNT(*) FROM ratings WHERE(ratings.website_id = #{id} AND ratings.love = 't' AND ratings.spec_id = specs.id))/(SELECT COUNT(*) FROM ratings WHERE(ratings.website_id = #{id} AND ratings.spec_id = specs.id))) as spec_rating, (SELECT COUNT(*) FROM ratings WHERE(ratings.website_id = #{id} AND ratings.spec_id = specs.id)) as spec_rating_number").order('spec_rating DESC, spec_rating_number DESC')
  end
  
  def specs_total
    Spec.joins(:texts).where('texts.website_id = ?', id)
  end
  
  def categories_by_size
    categories.select("categories.id, categories.cluster_id, (SELECT COUNT(*) FROM specs WHERE(specs.category_id = categories.id)) as spec_size").order('spec_size DESC')
  end
  
  def categories_by_alpha
    categories.order('texts.slug')
  end
  
  def categories
    Category.joins(:texts).where('texts.website_id' => id)
  end
  
  def specs
    specs_total.delete_if{|spec| spec.category.texts.website(self).empty? }.reverse
  end
  
  def count_elements
    website_count = {:specs => {:text => 0, :total => 0}, :categories => {:text => 0, :total => 0}}
    website_count[:specs][:text] = Text.where(:website_id => id, :textable_type => 'Spec').count
    website_count[:specs][:total] = Spec.joins(:category).where('categories.cluster_id' => cluster.id).count
    website_count[:categories][:text] = Text.where(:website_id => id, :textable_type => 'Category').count
    website_count[:categories][:total] = Category.where(:cluster_id => cluster.id).count
    website_count
  end
  
  def self.find_by_request request
    website = Website.where(:slug => request.host).first
    if website.nil?
      host_with_prefix = request.host + request.path.split('/').first
      website = Website.where(:slug => host_with_prefix).first
    end
    website.nil? ? false : website
  end

end
