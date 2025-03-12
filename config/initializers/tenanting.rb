Rails.application.configure do |config|
  # uuugh this resolver proc is so gross.
  config.middleware.use ActiveRecord::Tenanted::TenantSelector, "ApplicationRecord", ->(request) { request.subdomain.split(".").first }
end
