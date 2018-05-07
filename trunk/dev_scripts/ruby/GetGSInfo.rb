#!/usr/bin/env ruby
require 'find'
require 'inifile'
require 'clipboard'
require 'pathname'

class IniFile
  def write(opts = {})
    filename = opts.fetch(:filename, @filename)
    encoding = opts.fetch(:encoding, @encoding)
    mode = encoding ? "w:#{encoding}" : 'w'

    File.open(filename, mode) do |f|
      @ini.each do |section, hash|
        f.puts "[#{section}]"
        hash.each {|param, val| f.puts "#{param}#{@param}#{escape_value val}"}
        f.puts
      end
    end

    self
  end

  alias save write
end

def find_file(pwd = Dir.pwd, filename)
  puts filename
  begin
    file = 'NA'
    Find.find(pwd) do |path|
      Find.prune if path.include? '.git'
      # Find.prune if path.include? /\.\w+/
      if path.include?(filename)
        file = path
        puts file
      end
    end
  rescue StandardError
    puts 'Error reading files.'
  end
  if file == 'NA'
    return ''
  else
    Pathname.new(file).cleanpath.to_s
  end
end

# cur_dir = 'C:\tibco\TIB_gridserver_6.2.0'
# noinspection SpellCheckingInspection
cur_dir = 'C:\dev\lin64vm137.rofa.tibco.com'
cur_dir = ARGV[0] unless ARGV[0].nil?

Dir.chdir(cur_dir)

iniFile = IniFile.load('rsync.ini')
if iniFile.nil?
  puts "Requires rsync.ini file in #{cur_dir}"
  iniFile = IniFile.new
  iniFile['Settings'] = {
      'Primary' => `hostname -f`.chomp,
      'PrimaryDir' => cur_dir.to_s,
      'Engine' => `hostname -f`.chomp,
      'EngineDir' => cur_dir.to_s
  }
end

fullpath = find_file(cur_dir, 'gridserver.log')
puts "file 'gridserver.log' not found. " if fullpath == ''

text = File.read(fullpath) unless fullpath == ''

full_version = ''
jre_version = ''
unless text.nil?
  match = text.match(/\[(\d+.\d+.\d+.\d+)\ \(\d+.\d+/)
  full_version = Regexp.last_match(1)
  match = text.match(/\[JRE: (\d+.\d+.\d+_\d+)\//)
  jre_version = Regexp.last_match(1)
end

settings = iniFile['Settings']
primary = settings['Primary']

driver_log = find_file(cur_dir, 'driver.log')
puts "file 'driver.log' not found. " if driver_log == ''

# set properties
iniFile['GridServer Information'] = {
    'FullVersion' => full_version.to_s,
    'JREVersion' => jre_version.to_s,
    'GSLogPath' => "file://#{fullpath}",
    'DriverLogPath' => "file://#{driver_log}",
    'Comment1' => "Setting as Resolved. Workflow was successfully run on GS#{full_version} on http://#{primary}:8000 (see [^Logs_#{full_version}.zip])",
    'Comment2' => "Workflow was successfully run on GS#{full_version} on http://#{primary}:8000 (see [^Logs_#{full_version}.zip])",
    'Comment3' => "Problem was reproduced on GS#{full_version} on http://#{primary}:8000 (see [^Logs_#{full_version}.zip])",
    'Comment4' => "Resolved as not a bug. Could not reproduce problem on GS#{full_version} on http://#{primary}:8000 (see [^Logs_#{full_version}.zip])"
}
iniFile.write(filename: 'rsync2.ini')

Clipboard.copy full_version
puts "Workflow was run successfully on GS#{full_version} on #{primary} [^Logs_#{full_version}.zip]"
