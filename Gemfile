source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.1.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 6.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "devise"
gem "devise-jwt"
gem "friendly_id", "~> 5.5"
gem "pagy"
gem "pundit"
gem "audited", "~> 5.7"
gem "meta-tags"
gem "breadcrumbs_on_rails"
gem "rack-attack"
gem "rack-cors"
gem "lograge"
gem "sentry-ruby"
gem "sentry-rails"
gem "oj"
gem "image_processing", "~> 1.2"
gem "kamal", require: false
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv-rails"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rubocop-rails-omakase", require: false
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

group :development do
  gem "web-console"
  gem "letter_opener_web"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end
