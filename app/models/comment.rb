class Comment < ApplicationRecord
  include Messageable, Notifiable, Searchable

  belongs_to :creator, class_name: "User", default: -> { Current.user }
  has_many :reactions, dependent: :destroy

  searchable_by :body_plain_text, using: :comments_search_index, as: :body

  has_markdown :body

  before_destroy :cleanup_events

  private

  def cleanup_events
    # Delete events that reference through event_summary
    if message&.event_summary.present?
      Event.where(summary: message.event_summary).destroy_all
    end

    # Delete events that reference directly in particulars
    Event.where(particulars: { comment_id: id }).destroy_all
  end
end
