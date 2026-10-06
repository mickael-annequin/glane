# Previews of Devise's emails, at http://localhost:3000/rails/mailers (development only).
class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "fake-token")
  end
end
