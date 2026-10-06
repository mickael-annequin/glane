class ApplicationMailer < ActionMailer::Base
  # The sender address must be verified in Brevo. It is set in Render (MAIL_FROM).
  default from: email_address_with_name(ENV.fetch("MAIL_FROM", "no-reply@glane.test"), "Glane")
  layout "mailer"
end
