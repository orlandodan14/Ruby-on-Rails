# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "Example User Name",
             email: "example@mail.com") 

9.times do |n|
  name = "User_#{n}"
  email = "example#{n}@mail.com"
  User.create!(name: name,
               email: email)

end



users = User.take(9)

2.times do |n|
    description = "Event_#{n}"
    location = "Santo Domingo/ Calle #{n}/ Casa #{n * 2}"
    time1 = Time.now - n.weeks
    time2 = Time.now + n.weeks
    
    users.each do |user| 
        event1 = user.events.create!(location: location, description: description, date: time1)
        event2 = user.events.create!(location: location, description: description, date: time2)  
       # 6.times do #invitations for each event is 30
          #attendee details
         # freed_user_ids = (1..99).to_a #unique array list
         # freed_user_ids.delete(user.id)
         # random_user = User.find(freed_user_ids.delete(freed_user_ids.sample)) #finds random unique user
         # random_boolean = [true, false].sample           

         # event.attendees.create!(invited_user: random_user.username, accepted: random_boolean)
       # end
    end    
end