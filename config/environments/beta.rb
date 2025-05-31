require_relative "production"

Rails.application.configure do
  config.action_mailer.default_url_options = { host: "%{tenant}.37signals.works" }
end
