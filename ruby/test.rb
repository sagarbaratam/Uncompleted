name = 'sagar'
age = '25'
talent = 'not talented'
height = '5ft11inches'

puts "lets talk about #{name}"
puts "#{name} is #{age} years old"
puts "#{name} is #{talent} at all"
puts "#{name} is #{height} tall"

types_of_people = 10
x = "There are #{types_of_people} types of people"
binary = "binary"
donot = "don't"

y = "those who know #{binary} and those who #{donot}"

puts x
puts y

hilarious = false
evalu = "isn't that joke so funny! #{hilarious}"
puts evalu

w = "this is left side of string...."
e = "a string with right side"

puts w+e

puts "Mary had a little lamb."
puts " its fleece was white as #{'snow'}"
puts "and everywhere that mary went"
puts "."*10 #What'd that do?
end1 = "c"
end2 = "h"
end3 = "e"
end4 = "e"
end5 = "s"
end6 = "e"
end7 = "b"
end8 = "u"
end9 = "r"
end10 = "g"
end11 = "e"
end12 = "r"

print  end1+end2+end3+end4+end5+end6
puts  end7+end8+end9+end10+end11+end12

formatter = "%{first} %{second} %{third} %{fourth}"
puts formatter % {first: 1,second: 2,third: 3,fourth: 4}
puts formatter % {first: "one",second: "two",third: "three",fourth: "four"}
puts formatter % {first: true,second: false,third: true,fourth: false}
puts formatter % {first: formatter,second: formatter,third: formatter, fourth: formatter }
puts formatter % {
  first: "I had this thing.",
  second: "That you could type up right.",
  third: "But it didn't sing.",
  fourth: "So I said goodnight."
}

days = "mon tue wed thu fri sat sun"
months = "jan\nfeb\nmar\napr\nmay\njun\njul\naug\nsep\noct\nnov\ndec"

puts "Here are the days: #{days}"
puts "Here are the months: #{months}"

tabby_cat = "\tI'm tabbed in."
puts tabby_cat

fat_cat = "i'll do a list:\n\t*catfood\n\t*fishes\n\t*grass"
puts fat_cat

print "How old are you?"

age = gets.chomp

print " whats your sex?"

sex = gets.chomp

puts "So your age is #{age}, and your sex is #{sex}"

number1= age*24

puts "#{number1}"

print "Give me a number:"

number = gets.chomp.to_i

bigger = number*100

puts "A bigger number is #{bigger}"








 






