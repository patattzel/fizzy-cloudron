Rails.application.config.after_initialize do
  Account.multi_tenant = ENV["MULTI_TENANT"] == "true" || Rails.configuration.x.multi_tenant == true
end
