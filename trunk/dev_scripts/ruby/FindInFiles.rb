require 'yaml'

# noinspection SpellCheckingInspection
dirPath = 'C:\dev\lin64vm315.rofa.tibco.com';
unless ARGV[0].nil?
  dirPath = ARGV[0]
end


def findInFile (filepath, regexp)
  arr = []
  fileObj = File.new(filepath, 'r')
  count = 0
  while (line = fileObj.gets)
    count += 1
    line.scan(regexp) do |m1|
      arr << "#{filepath}:#{count}: #{line}"
    end
  end
  arr
end

file = File.new("#{dirPath}\\Report.process", 'w+')
Dir.chdir(dirPath) do
  Dir.glob('**/*.log').each do |name|
    # Check if it's in the file
    regexp_fragments = File.open("#{File.dirname(__FILE__)}/regexp_fragments.yaml") {|f| YAML.load(f)}
    regexp = Regexp.union(*regexp_fragments)
    arr = findInFile(name, regexp)
    if arr.length > 0
      arr.each { |e| file.puts e }
    end
  end
end
file.flush
file.close
`vs #{dirPath}/Report.process`

# def isInFile(filepath, text)
  # arr = []
  # fileObj = File.new(filepath, "r")
  # while (line = fileObj.gets)
    # line.scan(/#{text}/) do |m1|
      # return true;
    # end
  # end
  # return false;
# end

# def replaceInFiles(filepath)
#   puts "replacing file " + filepath
#   newfile = []
#
#   fileObj = File.new(filepath, "r")
#   while (line = fileObj.gets)
#     if (line.gsub!(/osp_dataSource::String keyString = row.getKey\(\);/, '// Downcasting to TableRow so that we can use it to parse the key only once. '))
#       newfile << line
#       line = fileObj.gets
#       line.gsub!(/osp_cppUtil::KeyParser keyParser;/, 'const osp_serverUtil::Key& key = (dynamic_cast<TableRow&>(row)).getKey();')
#       newfile << line
#       line = fileObj.gets
#       line = fileObj.gets
#       line = fileObj.gets
#     end
#     newfile << line
#   end
#   fileObj.close
#
#   File.open(filepath, "w") {|file| file.puts newfile}
# end
#