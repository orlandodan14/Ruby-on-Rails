require 'sinatra'
require 'sinatra/reloader' if development?


def cipher(string, num = 0)
  raise(ArgumentError, 'Argument is not numeric') unless num.is_a? Numeric
  alp = *("a".."z")
  alph = *("A".."Z")
  chars = string.split("")
  new_string = ""
  chars.each do |char|
    if alp.include?(char)
      index = alp.index(char)
      new_index = index + num
      if new_index > 25
        new_index -= 26
      end
      new_string << alp[new_index]
    elsif alph.include?(char)
      index = alph.index(char)
      new_index = index + num
      if new_index > 25
        new_index -= 26
      end
      new_string << alph[new_index]
    else
      char = char
      new_string << char
    end
  end
  new_string
end

answer = " "

get '/' do
  string = params['string'].to_s
  num = params['num'].to_i
  answer = cipher(string, num)
  erb :index, :locals => {:answer => answer}
end

#print "Enter any text: "
#string = gets.chomp.downcase
#print "Enter any number: "
#num = gets.chomp.to_i
#puts cipher(string, num)


