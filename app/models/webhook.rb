class Webhook < ApplicationRecord
  PERMITTED_SCHEMES = %w[ http https ].freeze

  encrypts :signing_secret
  has_secure_token :signing_secret

  has_many :deliveries, dependent: :delete_all

  validate :validate_url

  def deactivate
    update_columns active: false
  end

  private
    def validate_url
      uri = URI.parse(url.presence)

      if PERMITTED_SCHEMES.exclude?(uri.scheme)
        errors.add :url, "must use #{PERMITTED_SCHEMES.to_choice_sentence}"
      end
    rescue URI::InvalidURIError
      errors.add :url, "not a URL"
    end
end
