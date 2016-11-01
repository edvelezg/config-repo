# 1. To test this program simply press # between quotes
# 2. Try it when highlighting, and without highlighting

#!/usr/bin/env ruby
file_ip  = File.new("input.csv", "w")
pcnt=0
11.times do |n|
	11.times do |m|
		file_ip.puts "n,#{m},#{n+m}"
		pcnt+=1
	end
end
