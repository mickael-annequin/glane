# Creates the admin account (there is no public sign up).
# In production, the email and password come from environment variables set in Render.
# Running it again does nothing if the account already exists.
email = ENV.fetch("ADMIN_EMAIL") { "admin@glane.test" if Rails.env.development? }
password = ENV.fetch("ADMIN_PASSWORD") { "password" if Rails.env.development? }

if email.present? && password.present?
  User.find_or_create_by!(email: email) do |user|
    user.name = ENV.fetch("ADMIN_NAME", "Admin Glane")
    user.password = password
    user.admin = true
  end
  puts "Admin account ready: #{email}"
else
  puts "No admin account created: set ADMIN_EMAIL and ADMIN_PASSWORD."
end
