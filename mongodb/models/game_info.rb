class GameInfo
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  field :description
  field :manual
  field :notes
  field :categories
  field :meta_keywords
  field :website
  field :url
  field :screenshot
  field :screenshot_type
  field :rate
  field :width
  field :height
  field :old_id
  field :old_game_id
  field :keywords, type: Array
  
  belongs_to :game, class_name: 'Game', index: true
  
  index :keywords
  
  before_save :generate_keywords
  
  def generate_keywords
    keywords = Array.new
    keywords += title.to_keywords if title
    keywords += description.to_keywords if description
    keywords += manual.to_keywords if manual
    keywords += notes.to_keywords if notes
    keywords += categories.to_keywords if categories
    keywords += meta_keywords.to_keywords if meta_keywords
    keywords += website.to_keywords if website
    keywords += ( url.to_keywords - ['http','www'] ) if url
    self.keywords = keywords.uniq
  end
  
  def self.search query
    map = "function() {
      titles = new Array();
      titles.push(this.title);
      emit(this.game_id, {titles: titles, count: 1});
    };"
    reduce = " function(key, values) {
      var sum = 0;
      var titles = new Array();
      values.forEach(function(doc) {
        sum += doc.count;
        titles = titles.concat(doc.titles);
      });
      return {titles: titles, count: sum};
    };"
    collection.mapreduce(map, reduce, query: {keywords: /^#{query}/}, out: {inline: true}, raw: true)['results'].sort_by {|e| e['value']['count'] }.reverse
  end
  
end
