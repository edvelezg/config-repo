# 1. To test this program simply press Alt-R + 1
# 2. Or run run-ruby. Output shows up in build window

#!/usr/bin/env ruby
pcnt=0
11.times do |n|
	11.times do |m|
		puts "#{n},#{m},#{n+m}"
		pcnt+=1
	end
end
