# Opening hours as a weekly planning (days + time ranges) instead of a free text, so that reservations can be
# limited to them. The former free text is kept as an optional note ("sonner à l'entrée du parking"…).
class AddSchedulesToOrganizationsAndListings < ActiveRecord::Migration[8.1]
  def change
    # { "1" => [["09:00", "12:00"], ["14:00", "17:00"]], "4" => [["10:00", "16:00"]] } (1 = Monday … 7 = Sunday)
    add_column :organizations, :usual_schedule, :jsonb, null: false, default: {}
    rename_column :organizations, :usual_availability, :usual_availability_note

    add_column :listings, :schedule, :jsonb, null: false, default: {}
    rename_column :listings, :availability, :availability_note
    change_column_null :listings, :availability_note, true
  end
end
