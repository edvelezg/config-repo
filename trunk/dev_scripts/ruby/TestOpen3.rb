#!/usr/bin/env ruby

require 'open3'
puts "Enter the command for execution"
some_command=gets
stdout,stderr,status = Open3.capture3(some_command)
puts stdout
puts stderr
# STDERR.puts stderr
if status.success?
  puts stdout
  puts stderr
else
  STDERR.puts "#{stderr}"
end