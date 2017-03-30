require 'rest-client'

puts "What do you want yo search?"
input = gets.chomp

input = input.split(" ")
input = input.join("+")

results = RestClient.get "https://www.bing.com/search?q=#{input}&go=Submit&qs=ds&form=QBLH"


puts " "
puts "The body"
puts results.body
puts " "
puts "The code"
puts results.code
puts " "
puts "The headers"
puts results.headers
puts " "
puts "The raw_headers"
puts results.raw_headers
puts " "
puts "The cookies"
puts results.cookies
puts " "
puts "The coookie_jar"
puts results.cookie_jar
puts " "
puts "The request"
puts results.request
puts " "
puts "The history"
puts results.history