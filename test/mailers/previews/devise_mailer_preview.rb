# Previews of Devise's emails, at http://localhost:3000/rails/mailers (development only).
class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, "fake-token")
  end

  def invitation_instructions
    invited = User.new(email: "nouveau@exemple.fr", organization: Organization.first, invited_by: User.first,
                       invitation_created_at: Time.current, invitation_sent_at: Time.current)
    Devise::Mailer.invitation_instructions(invited, "fake-token")
  end
end
