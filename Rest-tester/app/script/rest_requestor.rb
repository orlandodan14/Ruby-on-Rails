require 'rest-client'

#I really don't know how to make a post request, so I think that part of this exercise is incorrect

puts "Type index, new, show, edit, create:"
input = gets.chomp
if input == "show"
  input = "1"
elsif input == "edit"
  input = "2"
elsif input == "create"
  input = "3"
else
  input = input
end
url = "http://localhost:3000/users/#{input}"
if input == "3"
  puts RestClient.post(url, "")
else  
  puts RestClient.get(url)  
end