# Demo data for the Proof of Concept presentation (docs/roadmap.md), loaded by db/seeds.rb only when DEMO_PASSWORD is set
# (in Render's Environment tab online). Each run deletes the previous demo data and creates it again, with dates counted
# from today: a "Manual Deploy" on Render the day before the presentation gives fresh listings.
#
# Fictitious structures in real towns of Eure-et-Loir. Accounts: <town>@demo.test (chartres, dreux, chateaudun, nogent,
# luce, bonneval), plus chartres.membre@demo.test. Phone numbers are in the ranges reserved for fiction (ARCEP).
password = ENV.fetch("DEMO_PASSWORD")

structures = [
  { login: "chartres", name: "Épicerie solidaire Le Grenier", address: "Place des Halles 28000 Chartres", city: "Chartres",
    latitude: 48.44393, longitude: 1.487962, phone: "02 61 91 00 01",
    usual_schedule: (1..5).to_h { |day| [ day.to_s, [ %w[09:00 12:00], %w[14:00 17:00] ] ] },
    people: [ [ "Claire Moulin", "06 39 98 00 01" ], [ "Hugo Lefèvre", nil ] ] },
  { login: "dreux", name: "Foyer d'hébergement Les Tilleuls", address: "Place Métézeau 28100 Dreux", city: "Dreux",
    latitude: 48.73577, longitude: 1.368172, phone: "02 61 91 00 02",
    usual_schedule: (1..6).to_h { |day| [ day.to_s, [ %w[10:00 16:00] ] ] }, usual_availability_note: "Sonner à l'accueil",
    people: [ [ "Samir Haddad", "06 39 98 00 02" ] ] },
  { login: "chateaudun", name: "Association Entraide Dunoise", address: "Place du 18 Octobre 28200 Châteaudun", city: "Châteaudun",
    latitude: 48.070261, longitude: 1.328718, phone: "02 61 91 00 03",
    usual_schedule: { "3" => [ %w[14:00 17:00] ], "6" => [ %w[09:00 12:00] ] },
    people: [ [ "Isabelle Roux", nil ] ] },
  { login: "nogent", name: "Épicerie sociale La Passerelle", address: "Place du Général Saint Pol 28400 Nogent-le-Rotrou",
    city: "Nogent-le-Rotrou", latitude: 48.322059, longitude: 0.820984, phone: "02 61 91 00 04",
    usual_schedule: { "1" => [ %w[09:00 12:00], %w[14:00 17:00] ], "4" => [ %w[09:00 12:00], %w[14:00 17:00] ] },
    people: [ [ "Antoine Girard", "06 39 98 00 04" ] ] },
  { login: "luce", name: "Restaurant solidaire Le Fournil", address: "Rue du Maréchal Leclerc 28110 Lucé", city: "Lucé",
    latitude: 48.434772, longitude: 1.468691, phone: "02 61 91 00 05",
    usual_schedule: (1..5).to_h { |day| [ day.to_s, [ %w[10:00 14:00] ] ] }, usual_availability_note: "Entrée par la cour, à gauche",
    people: [ [ "Fatou Diallo", "06 39 98 00 05" ] ] },
  { login: "bonneval", name: "Vestiaire solidaire L'Escale", address: "Place de l'Église 28800 Bonneval", city: "Bonneval",
    latitude: 48.181283, longitude: 1.386888, phone: "02 61 91 00 06",
    usual_schedule: { "5" => [ %w[14:00 18:00] ], "6" => [ %w[09:00 12:00] ] },
    people: [ [ "Jean-Marc Perrin", nil ] ] }
]

# Listings that can be reserved: [structure, category, title, days left, quantity, unit, storage, description].
available = [
  [ "chartres", "Produits laitiers, œufs", "Yaourts aux fruits", 2, "48", "piece", "chilled", "Date limite de consommation dans 4 jours" ],
  [ "chartres", "Bébé", "Couches taille 4", 30, "2", "box", nil, "Paquets fermés, 9-14 kg" ],
  [ "dreux", "Fruits et légumes", "Courgettes et tomates", 3, "4", "crate", nil, "Surplus du jardin partagé. Cagettes à rapporter" ],
  [ "dreux", "Produits laitiers, œufs", "Lait demi-écrémé", 12, "24", "liter", "ambient", "Briques UHT d'un litre" ],
  [ "chateaudun", "Épicerie sèche", "Pâtes et riz", 20, "3", "box", "ambient", nil ],
  [ "chateaudun", "Conserves", "Conserves de légumes", 60, "40", "piece", "ambient", "Haricots verts, petits pois, maïs" ],
  [ "nogent", "Surgelés", "Légumes surgelés", 15, "10", "kg", "frozen", "Prévoir une glacière" ],
  [ "nogent", "Hygiène, entretien", "Lessive liquide", 90, "12", "piece", nil, "Bidons de 3 litres" ],
  [ "luce", "Pain, viennoiseries", "Pain de la veille", 1, "20", "piece", nil, "Baguettes et pains de campagne" ],
  [ "luce", "Fruits et légumes", "Pommes", 6, "3", "crate", nil, nil ],
  [ "bonneval", "Boissons", "Jus de fruits", 30, "2", "box", "ambient", "Orange et multifruits, bouteilles d'un litre" ],
  [ "bonneval", "Bébé", "Lait infantile 2e âge", 45, "8", "piece", nil, "Boîtes de 800 g, non ouvertes" ]
]

# Reserved: [donor, beneficiary, category, title, days left, quantity, unit, storage, pickup in days (negative = past)].
# The Chartres one is past its slot: Chartres sees "Le stock est-il parti ?" in its "À faire" box.
reserved = [
  [ "chartres", "bonneval", "Pain, viennoiseries", "Brioches", 3, "15", "piece", nil, -1 ],
  [ "nogent", "dreux", "Produits laitiers, œufs", "Fromages à pâte dure", 10, "6", "kg", "chilled", 2 ],
  [ "chateaudun", "chartres", "Épicerie sèche", "Farine et sucre", 25, "1", "pallet", "ambient", 3 ]
]

# Picked up some days ago (the history): [donor, beneficiary, category, title, quantity, unit, days ago].
picked_up = [
  [ "chartres", "dreux", "Fruits et légumes", "Carottes", "25", "kg", 3 ],
  [ "dreux", "luce", "Pain, viennoiseries", "Viennoiseries", "40", "piece", 5 ],
  [ "luce", "chartres", "Conserves", "Thon en conserve", "30", "piece", 8 ],
  [ "bonneval", "nogent", "Hygiène, entretien", "Savons et dentifrices", "1", "box", 12 ]
]

def demo_category(name)
  # Falls back on "Autres" if the admin renamed a category online.
  Category.find_by(name: name) || Category.find_by!(catch_all: true)
end

def demo_listing(user, category, title, days, quantity, unit, storage, description = nil)
  listing = Listing.new_from(user)
  listing.update!(category: demo_category(category), title: title, available_until: days.days.from_now.to_date,
                  quantity: quantity, unit: unit, storage: storage, description: description)
  listing
end

# The first opening time of the listing, a given number of days from now: the closest open day after it,
# or before it for a slot in the past.
def demo_slot(listing, days)
  step = days.negative? ? -1 : 1
  day = (0..14).map { |offset| Date.current + days + step * offset }.find { |date| listing.opening_hours.open_on?(date) }
  Time.zone.parse("#{day} #{listing.opening_hours.ranges_on(day).first.first}")
end

# Without the validations: a slot in the past can't be chosen in the app.
def demo_reservation(listing, beneficiary, pickup_at)
  reservation = listing.reservations.new(organization: beneficiary.organization, user: beneficiary, pickup_at: pickup_at)
  reservation.save!(validate: false)
  listing.reserved!
  reservation
end

ActiveRecord::Base.transaction do
  # 1. Delete the previous demo data, including what was created during a demo (listings, invited members…).
  organization_ids = User.where("email LIKE ?", "%@demo.test").distinct.pluck(:organization_id)
  listings = Listing.where(organization_id: organization_ids)
  Reservation.where(listing: listings).or(Reservation.where(organization_id: organization_ids)).delete_all
  listings.find_each { |listing| listing.photos.purge }
  listings.delete_all
  User.where(organization_id: organization_ids).destroy_all
  Organization.where(id: organization_ids).destroy_all

  # 2. The structures and their people.
  users = structures.to_h do |data|
    organization = Organization.create!(data.except(:login, :people))
    people = data[:people].each_with_index.map do |(name, phone), index|
      User.create!(email: index.zero? ? "#{data[:login]}@demo.test" : "#{data[:login]}.membre@demo.test", password: password,
                   name: name, phone: phone, organization: organization, role: index.zero? ? :manager : :member)
    end
    [ data[:login], people.first ]
  end

  # 3. The listings.
  available.each do |login, *details|
    demo_listing(users[login], *details)
  end

  reserved.each do |donor, beneficiary, category, title, days, quantity, unit, storage, pickup_in|
    listing = demo_listing(users[donor], category, title, days, quantity, unit, storage)
    demo_reservation(listing, users[beneficiary], demo_slot(listing, pickup_in))
  end

  picked_up.each do |donor, beneficiary, category, title, quantity, unit, days_ago|
    listing = demo_listing(users[donor], category, title, 1, quantity, unit, nil)
    pickup_at = demo_slot(listing, -days_ago)
    reservation = demo_reservation(listing, users[beneficiary], pickup_at)
    reservation.pick_up!
    reservation.update_column(:closed_at, pickup_at + 1.hour)
    listing.update_columns(available_until: pickup_at.to_date + 2, created_at: pickup_at - 2.days)
  end
end

puts "Demo data ready: #{structures.size} structures, accounts <town>@demo.test (password: DEMO_PASSWORD)"
