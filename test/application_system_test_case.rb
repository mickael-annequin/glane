require "test_helper"

# System tests: a real Chrome, without a window, clicks in the app like a person (JavaScript included).
# Run them with `bin/rails test:system`; a failed test leaves a screenshot in tmp/screenshots.
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  driven_by :selenium, using: :headless_chrome, screen_size: [ 400, 900 ] # a phone screen

  # Also find the fields by their aria-label (e.g. the time menus of the planning: "Lundi, plage 1, début").
  Capybara.enable_aria_label = true
end
