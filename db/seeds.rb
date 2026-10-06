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

# Test data, on the developer's computer ONLY (never online: this file also runs at each deploy on Render).
# 4 fictitious structures, each with a manager and a member. Password of every account: "password".
if Rails.env.development?
  [
    { name: "Épicerie solidaire de Chartres", address: "12 Rue des Ecuyers 28000 Chartres", latitude: 48.446156, longitude: 1.490509,
      city: "Chartres", phone: "02 37 00 00 01", usual_availability: "Du lundi au vendredi, 9h–12h et 14h–17h",
      people: [ [ "Marie Dupont", "chartres.responsable" ], [ "Paul Martin", "chartres.membre" ] ] },
    { name: "Foyer d'accueil de Dreux", address: "Place Métézeau 28100 Dreux", latitude: 48.73577, longitude: 1.368172,
      city: "Dreux", phone: "02 37 00 00 02", usual_availability: "Mardi et jeudi, 10h–16h",
      people: [ [ "Sophie Leroy", "dreux.responsable" ], [ "Karim Benali", "dreux.membre" ] ] },
    { name: "Association d'entraide de Châteaudun", address: "Place du 18 Octobre 28200 Châteaudun", latitude: 48.070261, longitude: 1.328718,
      city: "Châteaudun", phone: nil, usual_availability: "Le mercredi après-midi",
      people: [ [ "Julie Petit", "chateaudun.responsable" ], [ "Luc Bernard", "chateaudun.membre" ] ] },
    # No usual availability: its manager sees the "À faire" box on the home page.
    { name: "CCAS de Nogent-le-Rotrou", address: "Place du Général Saint Pol 28400 Nogent-le-Rotrou", latitude: 48.322059, longitude: 0.820984,
      city: "Nogent-le-Rotrou", phone: "02 37 00 00 04", usual_availability: nil,
      people: [ [ "Nadia Moreau", "nogent.responsable" ], [ "Thomas Garnier", "nogent.membre" ] ] }
  ].each do |data|
    organization = Organization.find_or_create_by!(name: data[:name]) do |new_organization|
      new_organization.assign_attributes(data.except(:name, :people))
    end
    data[:people].each_with_index do |(name, login), index|
      User.find_or_create_by!(email: "#{login}@glane.test") do |user|
        user.name = name
        user.password = "password"
        user.organization = organization
        user.role = index.zero? ? :manager : :member
      end
    end
  end

  # A few listings, only on an empty table (their dates are counted from the day the seeds run).
  if Listing.none?
    [
      [ "chartres", "Produits laitiers, œufs", "Yaourts nature", 1, "40", "piece", "chilled", "Date de péremption : après-demain" ],
      [ "dreux", "Fruits et légumes", "Carottes", 3, "25", "kg", nil, "Cagettes à rapporter" ],
      [ "dreux", "Pain, viennoiseries", "Baguettes de la veille", 0, "30", "piece", nil, nil ],
      [ "chateaudun", "Épicerie sèche", "Pâtes et riz", 10, "12", "box", "ambient", nil ],
      [ "nogent", "Surgelés", "Légumes surgelés", 5, nil, nil, "frozen", "Prévoir une glacière" ],
      [ "chartres", "Autres", "Lessive", 30, "8", "piece", nil, "Bidons de 3 litres" ]
    ].each do |city, category, title, days, quantity, unit, storage, description|
      user = User.find_by!(email: "#{city}.responsable@glane.test")
      listing = Listing.new_from(user)
      listing.availability ||= "Sur rendez-vous"
      listing.update!(category: Category.find_by!(name: category), title: title, available_until: days.days.from_now.to_date,
                      quantity: quantity, unit: unit, storage: storage, description: description)
    end
  end

  puts "Test data ready: #{Organization.count} structures, #{User.count} accounts (password: password), #{Listing.count} listings"
end
