class Contact < ActiveRecord::Base
	validate :user_id, presense: true

	def self.import(file, user_id)
		CSV.foreach(file, headers: true) do |row|
			Contact.create!(name: row['name'], number: row['number'], user_id: user_id)
		end
	end

	def self.remove_dublicated_contacts(user_id)
		hash = []
		counter = 1

		dublicated_by_number = self.where(user_id: user_id)
		dublicated_by_number.each do |obj|
			counter+=1

			if hash.map(&:number).include? obj.number
		    obj.destroy!
		  elsif hash.map(&:name).include? obj.name
		  	obj.update_attribute(:name, "#{obj.name}_#{counter}")
		  	hash << obj
		  else
		    hash << obj
		  end
		end
	end
end
