module UuidPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid_primary_key
  end

  private

  def generate_uuid_primary_key
    return if id.present?
    self.id = SecureRandom.uuid_v7
  end
end
