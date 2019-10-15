filename = ARGV.first

puts "We are going to earse #{filename}"

puts "If you want this hit RETURN."

$stdin.gets

puts "Opening the file ...."

target = open(filename,'w')

puts "Truncating the file. Goodbye!"

target.truncate(0)

puts "Now I'm going to ak you three lines"

print "line1:"

line1 = $stdin.gets.chomp

print "line2:"

line2 = $stdin.gets.chomp

print "line3:"

line3 = $stdin.gets.chomp

puts "Im going to write these file."

target.write(line1)
target.write("\n")
target.write(line2)
target.write("\n")
target.write(line3)
target.write("\n")

puts "And finally , we will close it"

target.close




