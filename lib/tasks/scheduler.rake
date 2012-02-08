require 'processor'

task :process_messages => :environment do
  puts "Processing yesterdays ingoing messages..."
  Processor.process_new_messages(:in)
  puts "Processing yesterdays outgoing messages..."
  Processor.process_new_messages(:out)
  puts "done."
end