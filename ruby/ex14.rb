username =  ARGV.first

prompt = '>'

puts "Hi #{username}"

puts "Do you like me #{username}?"

puts prompt

likes = $stdin.gets.chomp

puts "where do you live? #{username}",prompt

lives = $stdin.gets.chomp

puts "Here are the facts i have got about you #{username}, your #{likes} me and you live at #{lives}"


