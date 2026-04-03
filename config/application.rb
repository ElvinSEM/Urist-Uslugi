require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module UristUslugi
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.time_zone = "Europe/Simferopol"
    config.i18n.default_locale = :ru
    config.active_job.queue_adapter = :solid_queue
    config.middleware.use Rack::Attack

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        request_specs: true,
        controller_specs: false,
        helper_specs: false,
        view_specs: false,
        routing_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.helper false
      g.assets false
    end
  end
end
