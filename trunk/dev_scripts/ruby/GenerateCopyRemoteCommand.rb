#!/usr/bin/env ruby
require "fileutils"
require "rubygems"
require "inifile"
require 'pp'
require 'pathname'
require 'clipboard'

def getCygPath(winPath)
  cmd = "cygpath #{winPath}"
  cygpath = `#{cmd}`.chomp
  return cygpath
end

filepath = ARGV[1].to_s     # 'C:\dev\lin64vm200.rofa.tibco.com\qa\datasynapse\manager\webapps\livecluster\WEB-INF\config\director.xml'
project_path = ARGV[0].to_s # 'C:\dev\lin64vm200.rofa.tibco.com'
cygpath = getCygPath(filepath)

FileUtils.cd(project_path, :verbose => true)

inifile = IniFile.load('rsync.ini')
if inifile.nil?
   puts "Requires rsync.ini file in #{current_dir}"
   exit
end

settings   = inifile["Settings"]
primary    = settings["Primary"]
primaryDir = settings["PrimaryDir"]
user = settings["User"]

mirror_folder = File.basename(primaryDir)
project_path = File.join(project_path, mirror_folder);
cyg_project_dir_length = getCygPath(project_path).length

relpath = cygpath[cyg_project_dir_length..-1]
remotePath = File.join(primaryDir, relpath)

puts remotePath
cmd = "scp #{cygpath} #{user}@#{primary}:#{remotePath}"
puts cmd
File.open(File.join(project_path, "CopyToRemote.bat"), "w") do |f|
	f.puts cmd
	f.puts 'pause'
	f.puts "exit"
end

system "start #{project_path}\\CopyToRemote.bat"
