#!/usr/bin/env ruby
require 'find'
require 'inifile'
require 'clipboard'

def find_file(pwd = Dir.pwd, str = "gridserver.log")
  file = ""
  begin
    Find.find(pwd) do |path|
      Find.prune if path.include? '.git'
      # puts path
      file = path if path.include?("#{str}")
    end
  rescue
    puts "Error reading files."
  end
  return file
end

cur_dir = 'C:\dev\lin64vm135.rofa.tibco.com'
if !ARGV[0].nil?
  cur_dir = ARGV[0]
end

Dir.chdir(cur_dir)

iniFile = IniFile.load('rsync.ini')
if iniFile.nil?
   puts "Requires rsync.ini file in #{cur_dir}"
   exit
end

fullpath = find_file(cur_dir, "gridserver.log")
if fullpath == ""
  puts "file 'gridserver.log' not found. "
  exit
end 

text = File.read(fullpath)
match = text.match(/\[(\d+.\d+.\d+.\d+)\ \(\d+.\d+/)
full_version = $1

settings   = iniFile["Settings"]
primary    = settings["Primary"]

# set properties
iniFile["GridServer Information"] = {
    "FullVersion" => "#{full_version}",
    "Path" => "#{fullpath}",
    "Exec" => 'command',
    "Comment" => "Workflow was run successfully on GS#{full_version} on #{primary} [^Logs_#{full_version}.zip]",
}
iniFile.write( :filename => 'rsync2.ini' )

Clipboard.copy full_version
puts "Workflow was run successfully on GS#{full_version} on #{primary} [^Logs_#{full_version}.zip]"
