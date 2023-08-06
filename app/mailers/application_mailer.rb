class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('GMAIL_SMTP_USER', nil)
  layout "mailer"
end
