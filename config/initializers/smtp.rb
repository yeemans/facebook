ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    domain: 'https://whispering-savannah-26016.herokuapp.com/',
    user_name: 'apikey',
    password: ENV['SENDGRID_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }