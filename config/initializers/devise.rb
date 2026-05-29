Devise.setup do |config|
  config.mailer_sender = ENV.fetch("DEFAULT_FROM_EMAIL", "no-reply@uristuslugi.local")
  require "devise/orm/active_record"
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth, :params_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.jwt do |jwt|
    jwt.secret = ENV.fetch("DEVISE_JWT_SECRET_KEY", "change-me")
    jwt.dispatch_requests = [
      ["POST", %r{^/users/sign_in$}],
      ["POST", %r{^/api/v1/auth/login$}]
    ]
    jwt.revocation_requests = [
      ["DELETE", %r{^/users/sign_out$}],
      ["DELETE", %r{^/api/v1/auth/logout$}]
    ]
    jwt.expiration_time = 30.days.to_i
  end
end
