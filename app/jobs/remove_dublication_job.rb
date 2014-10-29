require 'fileutils'
require 'benchmark'
require 'socket'

class RemoveDublicationJob

  @queue = IPSocket.getaddress(Socket.gethostname).to_sym

  def self.perform(user_id)
  	Contact.remove_dublicated_contacts(user_id)
  end
end