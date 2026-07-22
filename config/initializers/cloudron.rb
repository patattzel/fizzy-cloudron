# frozen_string_literal: true

require "fileutils"

# Cloudron captures STDOUT, but a persistent file log is useful when diagnosing
# restarts. Keep this initializer inert during regular development and tests.
Rails.application.configure do
  if ActiveModel::Type::Boolean.new.cast(ENV["SHOW_ERRORS"])
    config.consider_all_requests_local = true
    config.action_dispatch.show_exceptions = :all
  end

  if ENV["CLOUDRON_APP_DOMAIN"].present? || ENV["LOG_FILE"].present?
    log_dir = ENV.fetch("LOG_DIR", "/app/data/log")
    log_file = ENV.fetch("LOG_FILE") { File.join(log_dir, "#{Rails.env}.log") }

    begin
      FileUtils.mkdir_p(File.dirname(log_file))
      file_logger = ActiveSupport::Logger.new(log_file)
      file_logger.level = Rails.logger.level
      Rails.logger.broadcast_to(file_logger)
    rescue StandardError => error
      Rails.logger.warn "Cloudron log setup failed: #{error.class}: #{error.message}"
    end
  end
end
