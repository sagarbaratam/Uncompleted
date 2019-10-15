filename = ARGV.first

src = open(filename)

puts "Here is your file #{filename}"

print src.read

print "give the file name again:"
file_again = $stdin.gets.chomp
src_again = open(file_again)

print src_again.read


