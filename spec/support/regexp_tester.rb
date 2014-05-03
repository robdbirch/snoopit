#!/usr/bin/env ruby


#regexp = Regexp.new 'Total Number of records loaded'
regexp = Regexp.new 'Total Number of records:'
File.foreach 'snoop.log' do |line|
  regexp.match line do |m|
    puts "Match: #{m}"
  end
end