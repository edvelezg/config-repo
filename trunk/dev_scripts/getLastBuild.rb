#!/usr/bin/env ruby
require "rubygems"
require "clipboard"

cmd = 'ls -t \\\\netapp01c\\Build\\ | grep v4_2 | head -1'
text = %x[ #{cmd} ]
dir = '\\\\netapp01c\\Build\\' + text.chomp + '\\external-folders\\DataConnectors\\Kingdom'
puts dir

cmd2 = "ls -t #{dir} | grep Kingdom_ | head -1"
text2 = %x[ #{cmd2} ]
puts text2[/(v[\d_]*)/]
Clipboard.copy text2[/(v[\d_]*)/].chomp
