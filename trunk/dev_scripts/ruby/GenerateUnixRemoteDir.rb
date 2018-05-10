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

def getWinPath(cygpath)
  cmd = "cygpath -w #{cygpath}"
  winpath = `#{cmd}`.chomp
  return winpath
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
os = settings["OS"]

mirror_folder = File.basename(primaryDir)
mirror_path = File.join(project_path, mirror_folder);
cyg_mirror_dir_length = getCygPath(mirror_path).length

relpath = cygpath[cyg_mirror_dir_length..-1]
remotePath = File.join(primaryDir, relpath)

puts remotePath

if os == "Windows"
  remotePath = getWinPath(remotePath)
end

Clipboard.copy File.dirname(remotePath)
