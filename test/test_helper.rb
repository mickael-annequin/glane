ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # A planning open every day from 9h to 17h, as stored in the database.
    def every_day_9_to_17
      (1..7).to_h { |day| [ day.to_s, [ %w[09:00 17:00] ] ] }
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers

    # The planning fields as the form sends them (app/views/shared/_schedule_fields.html.erb).
    def schedule_form(days = { 1 => [ %w[09:00 12:00], %w[14:00 17:00] ] })
      days.to_h do |day, ranges|
        [ day.to_s, { "open" => "1", "ranges" => ranges.each_with_index.to_h { |(from, to), index| [ index.to_s, { "from" => from, "to" => to } ] } } ]
      end.merge("sent" => "1")
    end
  end
end
