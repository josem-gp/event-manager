require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = ENV.fetch('TZ', 'Asia/Tokyo')
    # /lib modules were not loaded automatically so I added this fix:
    # https://stackoverflow.com/questions/1073076/rails-lib-modules-and
    config.autoload_paths += %W(#{config.root}/lib)
    # Configuration to enqueue jobs using Sidekiq
    config.active_job.queue_adapter = :sidekiq
    # Using logger
    Rails.logger = Logger.new(STDOUT)
    config.logger = ActiveSupport::Logger.new("log/#{ENV["RAILS_ENV"]}.log")
  end
end
