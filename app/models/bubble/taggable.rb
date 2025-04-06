module Bubble::Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    scope :tagged_with, ->(tags) { joins(:taggings).where(taggings: { tag: tags }) }
  end

  def toggle_tag(title)
    transaction do
      tag = find_or_create_tag_with_title(title)
      tagged_with?(title) ? untagging(tag) : tagging(tag)
    end
  end

  def tagged_with?(title)
    tags.exists?(title: title)
  end

  private
    def find_or_create_tag_with_title(title)
      bucket.account.tags.find_or_create_by!(title: title)
    end

    def find_tag_by_title(title)
      bucket.account.tags.find_by(title: title)
    end

    def tagging(tag)
      taggings.create tag: tag
    end

    def untagging(tag)
      taggings.destroy_by tag: tag
    end
end
