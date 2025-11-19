ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::DiskController.after_action only: :show do
    expires_in 5.minutes, public: true
  end
end

# Use DB read/write splitting for Active Storage models
ActiveSupport.on_load(:active_storage_record) do
  connects_to database: { writing: :primary, reading: :replica }
end

module ActiveStorageControllerExtensions
  extend ActiveSupport::Concern

  included do
    before_action do
      # Add script_name so that Disk Service will generate correct URLs for uploads
      ActiveStorage::Current.url_options = {
        protocol: request.protocol,
        host: request.host,
        port: request.port,
        script_name: request.script_name
      }
    end
  end
end

Rails.application.config.to_prepare do
  ActiveStorage::BaseController.include ActiveStorageControllerExtensions
end
