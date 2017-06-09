class PassengerMailer < ApplicationMailer
  default from: 'flight_booker_team@example.com'
  
  def thank_you(user)
    @user = user
    mail(to: @user.email, subject: "Thank you!")
  end
end
