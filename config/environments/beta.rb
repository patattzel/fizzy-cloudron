require_relative "production"

Rails.application.configure do
  config.action_mailer.default_url_options = { host: "%{tenant}.37signals.works" }

  # I couldn't figure out how to configure Pure to allow updates from Kevin's digital ocean instance.
  config.active_storage.service = :local
end
