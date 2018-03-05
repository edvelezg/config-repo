# Copyright (c) 2018 TIBCO Software Inc. All Rights Reserved.
# Requires both Cygwin and gem inifile, to install use the command: 'gem install inifile'
# Requires: 'gem install highline'
# Cygwin found in https://cygwin.com/setup-x86_64.exe

require 'inifile'
require 'pp'
require "fileutils"
require "clipboard"
require "highline/system_extensions"
include HighLine::SystemExtensions

current_dir = Dir.pwd
script_dir = File.join(__dir__, "BuildMirrorProject")

# Change to the script's directory and download aliases, functions and bash_profile to be copied over.
Dir.chdir(script_dir)

puts `SET PATH="%PATH%;C:\Program Files\Git\bin\"`
puts "Downloading files to be copied from: #{script_dir}"
puts `download.bat`

Dir.chdir(current_dir)
# Read the ini file that specifies how the project is to be built
file       = IniFile.load('rsync.ini')
if file.nil?
   puts "Requires rsync.ini file in #{current_dir}"
   exit
end

# pretty print object
puts "Loaded the rsync.ini as follows:"
pp file
print "Press any key to continue:"
k = get_character
puts k.chr

settings   = file["Settings"]
primary    = settings["Primary"]
primaryDir = settings["PrimaryDir"]
engine     = settings["Engine"]
engineDir  = settings["EngineDir"]
user = settings["User"]

mirror_primaryDir = File.basename(primaryDir)
mirror_engineDir = File.basename(engineDir)

project_dir = File.join(current_dir, primary)
puts "===============Creating the project directory================"
puts "project_dir: #{project_dir}"
FileUtils::mkdir_p project_dir
puts "engine_dir:  #{project_dir}/#{engine}/#{mirror_engineDir}"
FileUtils::mkdir_p "#{project_dir}/#{engine}/#{mirror_engineDir}"

cyg_project_dir = `cygpath "#{project_dir}"`.chomp
puts "cyg_project_dir: #{cyg_project_dir}"

Dir.chdir(project_dir)
print "Press any key to continue:"
k = get_character
puts k.chr

# Create the .gitignore file
open(".gitignore", "w") do |io|
  io.puts "*.class"
  io.puts "*.#ds_updatecache"
  io.puts "*.#dsDirID"
  io.puts "*.#dslock"
  io.puts "*.1"
  io.puts "*.bfc"
  io.puts "*.cfg"
  io.puts "*.dat"
  io.puts "*.data"
  io.puts "*.a"
  io.puts "*.so"
  io.puts "*.png"
  io.puts "*.gif"
  io.puts "*.vpwhist"
  io.puts "*.vtg"
  io.puts "*.java"
end

# Create the pull.bat file
open("pull.bat", "w") do |io|
  orig = "#{primary}:#{primaryDir}"
  dest = "#{cyg_project_dir}/#{mirror_primaryDir}"
  io.puts "rsync -avz --exclude '.git' --exclude 'lost+found' --exclude-from '.gitignore' --delete #{user}@#{orig}/* '#{dest}'"
  
  orig = "#{engine}:#{engineDir}"
  dest = "#{cyg_project_dir}/#{engine}/#{mirror_engineDir}"
  io.puts "rsync -avz --exclude '.git' --delete #{user}@#{orig}/* '#{dest}'"
end

# Create the rsync.ini file
FileUtils.copy_file(File.join(current_dir, "rsync.ini"), "rsync.ini")

# I have not found a good way to copy the key for auto-ssh using a script 
puts "==========================================================================="
puts "I have not found a good way to copy the key for auto-ssh using a script_dir"
puts "Thus, copying the following commands into the clibpoard:"
cmd = "ssh-copy-id #{user}\@#{primary}"
puts "#{cmd}"
Clipboard.copy cmd.chomp
cmd = "ssh-copy-id #{user}\@#{engine}"
puts "#{cmd}"
Clipboard.copy cmd.chomp
puts "==========================================================================="
#puts "bash -c \"ssh-copy-id #{user}\@#{primary}\""
#puts `bash -c \"ssh-copy-id #{user}\@#{primary}\"`

def scp_file_to_unix(script_dir, filename, user, primary)
  orig = "#{File.join(script_dir, filename).to_s}"
  cyg_orig = `cygpath "#{orig}"`.chomp
  dest = "#{user}@#{primary}:/home/#{user}"

  puts "scp '#{cyg_orig}' #{dest}"
  puts `scp '#{cyg_orig}' #{dest}`
end

scp_file_to_unix(script_dir, ".bash_profile", user, primary)
scp_file_to_unix(script_dir, ".aliases"     , user, primary)
scp_file_to_unix(script_dir, ".functions"   , user, primary)

scp_file_to_unix(script_dir, ".bash_profile", user, engine)
scp_file_to_unix(script_dir, ".aliases"     , user, engine)
scp_file_to_unix(script_dir, ".functions"   , user, engine)

def execute_cmd(cmd)
  # Shell execution in ruby
  # https://gist.github.com/JosephPecoraro/4069
  puts `#{cmd}`
end

# Execute git commands to init repo
# https://ayende.com/blog/4749/executing-tortoisegit-from-the-command-line
execute_cmd('TortoiseGitProc /command:repocreate')
execute_cmd('TortoiseGitProc /command:commit /path:. /logmsg:"init files + ignored files" /closeonend:3')
