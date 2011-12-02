class Upload < ActiveRecord::Base
	belongs_to :profil
	serialize :titles
	validates :titles, :presence => true, :uniqueness => true
	reg = /^[a-z0-9-]*$/
	validates :file_name, :presence => true, :uniqueness => true, :length => {:maximum => 40}, :format => reg
	validates :descriptions, :presence => true
	validates :author, :presence => true, :length => {:maximum => 200}
	validates :keywords, :presence => true, :format => /^[^,]*$/
	validates :mov, :presence => true
	validates_attachment_presence :mov
	validates :profil_id, :presence => true
	has_attached_file :mov
	has_many :tasks
	accepts_nested_attributes_for :tasks
	before_create :ajust_file_name
	def process
		Task.process_by_upload id
	end
	def ajust_file_name
		self.mov.instance_write(:file_name, file_name+'.mov')
	end
	def tasks_completed
		tasks.reject {|task| task.time_taken.nil? || task.status != 'success'}
	end
	def time_given
		((mov.size.to_f*5/100000) + 180).to_i
	end
	def time_taken_total
		tasks_completed.inject(0.0) {|sum,task| sum + task.time_taken}
	end
	def task_time_maximum
		tasks_completed.inject {|max,task| task.time_taken > max.time_taken ? task : max}
	end
	def task_time_minimum
		tasks_completed.inject {|min,task| task.time_taken < min.time_taken ? task : min}
	end
	def time_taken_average
		time_taken_total/tasks_completed.size
	end
	def description_rand
		descriptions_a.sort_by{rand}[0]
	end
	def keywords_comma_rand
		tab = keywords_a.sort_by{rand}[0]
		tab = tab.split(" ").delete_if{|e| e.empty?}
		tab.join(",")
	end
	def keywords_space_rand
		keywords_a.sort_by{rand}[0]
	end
	def keywords_semi_rand
		tab = keywords_a.sort_by{rand}[0]
		tab = tab.split(" ").delete_if{|e| e.empty?}
		tab.join(";")
	end
	def title_rand
		titles_a.sort_by{rand}[0]
	end
	def login_for website
		profil.accounts.find_by_hosting_id(Hosting.find_by_name(website).id).login
	end
	def password_for website
		profil.accounts.find_by_hosting_id(Hosting.find_by_name(website).id).password
	end
	def titles_a
		titles.split("\r\n").delete_if{|e| e.empty?}
	end
	def descriptions_a
		descriptions.split("\r\n").delete_if{|e| e.empty?}
	end
	def keywords_a
		keywords.downcase.split("\r\n").delete_if{|e| e.empty?}
	end
	def clean_tasks
		tasks.each do |task|
			if task.status == "1"
				task.status = "pending"
				task.save!
			elsif task.status == "0"
				task.destroy
			end
		end
	end
	def clean_lazy_tasks
		tasks.each do |task|
			if task.status == "1" || task.status == "0" 
				task.destroy
			end
		end
	end
end
