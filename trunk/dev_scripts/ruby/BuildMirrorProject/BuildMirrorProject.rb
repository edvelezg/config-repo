# Copyright (c) 2018 TIBCO Software Inc. All Rights Reserved.

require 'inifile'
require 'pp'
require "fileutils"

# Change to the script's directory.
Dir.chdir(__dir__)

script_dir = Dir.pwd
project_dir = Dir.pwd # TODO: replace with File.expand_path("..", Dir.pwd)
cyg_project_dir = `cygpath "#{project_dir}"`.chomp

puts script_dir
puts project_dir
puts cyg_project_dir

# Read the ini file that specifies how the project is to be built
file       = IniFile.load('BuildMirrorProject.ini')

# pretty print object
puts "here is the loaded file BuildMirrorProject.ini:"
pp file

settings   = file["Settings"]
primary    = settings["Primary"]
primaryDir = settings["PrimaryDir"]
engine     = settings["Engine"]
engineDir  = settings["EngineDir"]
user = settings["User"]

mirror_primaryDir = File.basename(primaryDir)
# puts File.basename(primaryDir)

mirror_engineDir = File.basename(engineDir)
# puts File.basename(engineDir)

FileUtils::mkdir_p File.join(project_dir, primary)
# Dir.mkdir()
Dir.chdir(primary)

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
  dest = "#{cyg_project_dir}/#{primary}/#{mirror_primaryDir}"
  io.puts "rsync -avz --exclude '.git' --exclude 'lost+found' --delete #{user}@#{orig}/* '#{dest}'"
  
  orig = "#{engine}:#{engineDir}"
  dest = "#{cyg_project_dir}/#{primary}/#{engine}/#{mirror_engineDir}"
  io.puts "rsync -avz --exclude '.git' --delete #{user}@#{orig}/* '#{dest}'"
end

# Create the rsync.ini file
FileUtils.copy_file(File.join(script_dir, "BuildMirrorProject.ini"), "rsync.ini")

#puts "bash -c \"ssh-copy-id #{user}@#{primary}\""
#puts `bash -c \"ssh-copy-id #{user}@#{primary}\"`

def scp_file_to_unix(script_dir, filename, user, primary)
  orig = "#{File.join(script_dir, filename).to_s}"
  cyg_orig = `cygpath "#{orig}"`.chomp
  dest = "#{user}@#{primary}:/home/#{user}"

  puts "scp '#{cyg_orig}' #{dest}"
  puts `scp '#{cyg_orig}' #{dest}`
end

#scp_file_to_unix(script_dir, ".bash_profile", user, primary)
#scp_file_to_unix(script_dir, ".aliases"     , user, primary)
#scp_file_to_unix(script_dir, ".functions"   , user, primary)

#puts "scp \"#{File.join(script_dir, ".aliases").to_s}\"      #{user}@#{primary}:/home/#{user}"
#puts "scp \"#{File.join(script_dir, ".functions").to_s}\"    #{user}@#{primary}:/home/#{user}"

#puts `scp "\"#{File.join(#{script_dir}, ".bash_profile").to_s}\" #{user}@#{primary}:/home/#{user}"`
#puts `scp "\"#{File.join(#{script_dir}, ".aliases").to_s}\"      #{user}@#{primary}:/home/#{user}"`
#puts `scp "\"#{File.join(#{script_dir}, ".functions").to_s}\"    #{user}@#{primary}:/home/#{user}"`

# Execute git commands to init repo
#puts `TortoiseGitProc \/command:repocreate`
def execute_cmd(cmd)
  # Shell execution in ruby
  # https://gist.github.com/JosephPecoraro/4069
  puts `#{cmd}`
end

# Execute git commands to build mirror
#https://ayende.com/blog/4749/executing-tortoisegit-from-the-command-line
execute_cmd('TortoiseGitProc /command:repocreate')
execute_cmd('TortoiseGitProc /command:commit /path:. /logmsg:"init files + ignored files" /closeonend:3')
#puts `TortoiseGitProc `

#puts `TortoiseGitProc \/command:repocreate`
#"C:\Program Files\TortoiseGit\bin\TortoiseGitProc.exe" /command:ignore /path:"%CD%\%Primary%.vtg*%CD%\%Primary%.vpwhist" /logmsg:"SE files to be ignored" /closeonend:2

