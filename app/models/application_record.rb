class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include ColumnLimits

  configure_replica_connections

  attribute :id, :uuid, default: -> { ActiveRecord::Type::Uuid.generate }
end
