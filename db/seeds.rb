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

# Provisional categories (docs/conception/wireframes.md, screen 12), only on an empty table:
# afterwards the admin manages them in the admin space, and a renamed category must not come back at the next deploy.
if Category.none?
  [
    [ "Fruits et légumes", "🥕" ],
    [ "Produits laitiers, œufs", "🥛" ],
    [ "Viande, poisson", "🍗" ],
    [ "Épicerie sèche", "🍝" ],
    [ "Conserves", "🥫" ],
    [ "Pain, viennoiseries", "🥖" ],
    [ "Surgelés", "🧊" ],
    [ "Boissons", "🧃" ]
  ].each { |name, icon| Category.create!(name: name, icon: icon) }
  Category.create!(name: "Autres", icon: "📦", catch_all: true)
  puts "Categories created: #{Category.count}"
end
