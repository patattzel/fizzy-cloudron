Rails.application.config.x.local_authentication = ENV["LOCAL_AUTHENTICATION"].present? || ENV["SAAS_EXTENSION"].blank?
