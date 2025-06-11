require "signal_id"

Rails.application.config.to_prepare do
  SignalId::Database.load_configuration SignalId::Database.default_configuration
  SignalId::Database.enable_rw_splitting!
end

Rails.application.config.after_initialize do
  ActiveRecord.yaml_column_permitted_classes << SignalId::PersonName
end
