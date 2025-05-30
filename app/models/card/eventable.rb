module Card::Eventable
  extend ActiveSupport::Concern

  include ::Eventable

  included do
    before_create { self.last_active_at = Time.current }

    after_save :track_title_change, if: :saved_change_to_title?
    after_save :track_collection_change, if: :saved_change_to_collection_id?
  end

  def event_was_created(event)
    transaction do
      create_system_comment_for(event)
      touch(:last_active_at)
    end
  end

  private
    def should_track_event?
      published?
    end

    def track_title_change
      if title_before_last_save.present?
        track_event "title_changed", particulars: { old_title: title_before_last_save, new_title: title }
      end
    end

    def track_collection_change
      old_collection = Collection.find_by(id: collection_id_before_last_save)
      
      if old_collection.present?
        track_event "collection_changed", particulars: { 
          old_collection: old_collection.name,
          new_collection: collection.name
        }
      end
    end

    def create_system_comment_for(event)
      SystemCommenter.new(self, event).comment
    end
end
