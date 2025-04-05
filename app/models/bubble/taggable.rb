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
      tagged_with?(tag) ? untag_with(tag) : tag_with(tag)
    end
  end

  def tagged_with?(tag)
    tags.include? tag
  end

  private
    def find_or_create_tag_with_title(title)
      bucket.account.tags.find_or_create_by!(title: title)
    end

    def tag_with(tag)
      taggings.create tag: tag
    end

    def untag_with(tag)
      taggings.destroy_by tag: tag
    end
end
