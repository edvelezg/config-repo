def findInFile (filepath, regexp)
  arr = []
  fileObj = File.new(filepath, "r")
  count = 0
  while (line = fileObj.gets)
    count += 1
    line.scan(regexp) do |m1|
      arr << "#{filepath}:#{count}: #{line}"
    end
  end
  return arr
end

dirPath = "C:\\dev\\lin64vm315.rofa.tibco.com";
if !ARGV[0].nil?
  dirPath = ARGV[0]
end

file = File.new("#{dirPath}\\Report.txt", 'w+')

Dir.chdir(dirPath) do
  Dir.glob("**/*.log").each do |name|
    # Check if it's in the file
    regexp = Regexp.union(/SEVERE/,/WARNING/, /Exception:/)
    arr = findInFile(name, regexp)
    if arr.length > 0
      arr.each { |e| file.puts e }
    end
  end
end
file.flush
`vs #{dirPath}/Report.txt`


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