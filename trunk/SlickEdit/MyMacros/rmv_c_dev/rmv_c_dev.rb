#!/usr/bin/env	ruby
str = STDIN.read

# str	=	'C:\dev\DC-Petra\trunk\.classpath
# C:\dev\DC-Petra\trunk\C++\osp\plugin\data\petra\PetraEntity.cpp
# C:\dev\DC-Petra\trunk\C++\osp\plugin\data\petra\PetraEntityFactory.cpp
# C:\dev\DC-Petra\trunk\C++\osp\plugin\data\petra\PetraNativeOffsetMap.cpp
# C:\dev\DC-Petra\trunk\C++\osp\plugin\data\petra\PetraTableConnection.cpp
# C:\dev\DC-Petra\trunk\C++\osp\plugin\data\petra\PetraTableIterator.cpp
# C:\dev\DC-Petra\trunk\Metadata\MetaModel-3.xml
# '

num = ARGV[0].to_i
val, prj = '', ''; 
if str.include? "DC-Petra"
   val, prj = 'DC-Petra', 'OSPPE'
end
if str.include? "DC-Kingdom"
   val, prj = 'DC-Kingdom', 'OSPKD'
end

puts "Checkin - #{val} (#{prj}-#{num})"
puts "#{prj}-#{num}: "
dest = str.gsub!('C:\dev', '   ')
print dest

