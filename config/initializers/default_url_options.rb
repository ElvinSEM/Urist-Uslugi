Rails.application.routes.default_url_options[:host] = ENV.fetch("APP_HOST", "localhost:3000")
