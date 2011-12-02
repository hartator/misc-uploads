class Info < ActiveRecord::Base
  
  belongs_to :game
  
  def self.find_by_contents query
    fields_to_inspect = "description like ? OR title like ? OR manual like ? OR url like ? OR categories like ? OR notes like ?"
    results = find(:all, :include => 'game', :conditions => [fields_to_inspect, *["%#{query}%"]*6])
    games_with_titles = Hash.new
    results.each do |info|
      unless games_with_titles.include? info.game
        games_with_titles[info.game] = [info.title]
      else
        games_with_titles[info.game] << info.title
      end
    end
    games_with_titles = games_with_titles.sort_by { |k,v| v.size }.reverse
    games_with_titles
  end
  
end