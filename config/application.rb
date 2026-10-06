require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Glane
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Paris"
    config.i18n.default_locale = :fr
    # Texts not yet translated into French are shown in English instead of an error.
    config.i18n.fallbacks = [ :en ]

    # Glane starts in Eure-et-Loir: address suggestions favor this department and the area around Chartres.
    # To open Glane to another territory, change these values (nothing else is tied to Eure-et-Loir).
    config.x.territory = { department_code: "28", latitude: 48.45, longitude: 1.40 }
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
