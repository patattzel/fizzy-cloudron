module Bubble::Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    scope :tagged_with, ->(tags) { joins(:taggings).where(taggings: { tag: tags }) }
  end

  def toggle_tag_with(title)
    tag = bucket.account.tags.find_or_create_by!(title: title)
    transaction { tagged_with?(tag) ? untagging(tag) : tagging(tag) }
  end

  def tagged_with?(tag)
    tags.include? tag
  end

  private
    def tagging(tag)
      taggings.create tag: tag
    end

    def untagging(tag)
      taggings.destroy_by tag: tag
    end
end
