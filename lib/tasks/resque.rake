require 'resque/tasks'
require 'resque_scheduler/tasks'

task 'resque:setup' => :environment do
  puts "setting up resque"
end
