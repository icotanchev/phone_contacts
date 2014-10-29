require 'fileutils'
require 'benchmark'
require 'socket'

class ContactsExportJob
	extend ExportImportJob

  @queue = IPSocket.getaddress(Socket.gethostname).to_sym

  def self.perform(export_file_id, user_id, *params)
  	export_file = FileOperation.find(export_file_id)
  	contacts = Contact.find(params.first['ids'])

  	perform_with_logging(export_file) do
  		file = File.open(export_file.file_path, "w")
  		generate_csv(contacts, file)
  		file.close
    end
  end

  private

  def self.generate_csv(obj, file)
  	file << column_names.join(";") + "\n"
  	obj.each do |row|
  		file << row_content(row).join(";") + "\n"
  	end
  end

  def self.column_names
  	['Name', 'Number']
  end

   def self.row_content(obj)
    [ 
      obj.name,
      obj.number,
    ]
  end
end