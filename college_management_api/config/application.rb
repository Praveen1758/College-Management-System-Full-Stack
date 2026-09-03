require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module CollegeManagementApi
  class Application < Rails::Application
    config.load_defaults 8.1

    config.middleware.use Rack::Attack
    config.active_job.queue_adapter = :sidekiq
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true
  end
end
