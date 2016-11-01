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

dest = str.gsub!('C:\dev', '   ')
print dest

