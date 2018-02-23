def find_directories(pwd = Dir.pwd)
  directories = []
  begin
    Find.find(pwd) do |path|
      Find.prune if path.include? '.git'
      next unless File.directory?(path)
      directories << path
    end
  rescue
    puts "Error reading files."
  end
  directories
end

def find_files(pwd = Dir.pwd)
  files = []
  begin
    Find.find(pwd) do |path|
      Find.prune if path.include? '.git'
      next if path.include? 'picasa'
      next unless File.file?(path)
      files << path
    end
  rescue
    puts "Error reading files."
  end
  files
end