require 'fileutils'
require 'benchmark'
require 'socket'

class ContactsImportJob
	extend ExportImportJob

  @queue = IPSocket.getaddress(Socket.gethostname).to_sym

  def self.perform(export_file_id, user_id, *params)
  	export_file = FileOperation.find(export_file_id)

  	perform_with_logging(export_file) do
      Contact.import(export_file.file_path, user_id)
    end
  end
end