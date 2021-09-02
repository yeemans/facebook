class RegistrationMailer < ApplicationMailer
  default from: 'arthur.roth.07@gmail.com'

  def registration_email 
    @user = params[:user]
    mail(to: @user.email, subject: "You registered!")
  end
end
