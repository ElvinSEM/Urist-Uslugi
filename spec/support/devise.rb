RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers, type: :system

  config.before(:suite) do
    Warden.test_mode!
  end

  config.after(type: :system) do
    Warden.test_reset!
  end

  config.after(:suite) do
    Warden.test_reset!
  end
end
