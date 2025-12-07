# frozen_string_literal: true

# Configure runtime settings driven by the environment so the app can boot
# cleanly when packaged (e.g. Cloudron).
Rails.application.configure do
  # Default production log level is :fatal in this repo; relax it for packaged deployments
  # so Fehler und Requests im STDOUT landen (überschreibbar via LOG_LEVEL).
  config.log_level = ENV.fetch("LOG_LEVEL", "info").to_sym

  # Fehlerseiten wieder wie Production, es sei denn SHOW_ERRORS explizit setzen.
  if ENV.fetch("SHOW_ERRORS", "false") == "true"
    config.consider_all_requests_local = true
    config.action_dispatch.show_exceptions = :all
  end

  log_dir = ENV.fetch("LOG_DIR", "/app/data/log")
  log_file = ENV.fetch("LOG_FILE") { File.join(log_dir, "#{Rails.env}.log") }

  begin
    FileUtils.mkdir_p(File.dirname(log_file))
    file_logger = ActiveSupport::Logger.new(log_file)
    file_logger.level = config.log_level
    Rails.logger.extend ActiveSupport::Logger.broadcast(file_logger)
  rescue => e
    Rails.logger.warn "Cloudron log setup failed: #{e.class}: #{e.message}"
  end

  host = ENV["APP_HOST"] || ENV["CLOUDRON_APP_DOMAIN"]
  origin = ENV["APP_ORIGIN"] || ENV["CLOUDRON_APP_ORIGIN"]
  protocol = ENV["APP_PROTOCOL"] || origin&.split("://")&.first || "https"

  if host
    routes = Rails.application.routes
    routes.default_url_options[:host] = host
    routes.default_url_options[:protocol] = protocol

    config.action_mailer.default_url_options ||= {}
    config.action_mailer.default_url_options[:host] ||= host
    config.action_mailer.default_url_options[:protocol] ||= protocol
  end

  from_address = ENV["MAILER_FROM_ADDRESS"] || ENV["MAIL_FROM"]
  if from_address
    config.action_mailer.default_options = config.action_mailer.default_options.to_h.merge(from: from_address)
  end

  smtp_address = ENV["SMTP_ADDRESS"] || ENV["SMTP_HOST"] || ENV["MAIL_SMTP_SERVER"]
  if smtp_address
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: smtp_address,
      port: Integer(ENV.fetch("SMTP_PORT", ENV.fetch("MAIL_SMTP_PORT", 587))),
      domain: ENV["SMTP_DOMAIN"] || ENV["MAIL_DOMAIN"] || host,
      user_name: ENV["SMTP_USERNAME"] || ENV["MAIL_SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"] || ENV["MAIL_SMTP_PASSWORD"],
      authentication: :login,
      enable_starttls_auto: ENV.fetch("SMTP_ENABLE_STARTTLS_AUTO", "true") != "false"
    }.compact
  end
end
