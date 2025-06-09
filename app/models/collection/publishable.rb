module Collection::Publishable
  extend ActiveSupport::Concern

  included do
    has_one :publication, class_name: "Collection::Publication", dependent: :destroy
    scope :published, ->{ joins(:publication) }
  end

  def published?
    publication.present?
  end

  def publish
    create_publication! unless published?
  end

  def unpublish
    publication&.destroy
  end
end
