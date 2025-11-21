module Searchable
  extend ActiveSupport::Concern

  included do
    has_one :search_record, class_name: "Search::Record", as: :searchable

    before_save :ensure_current_account
    after_create_commit :create_in_search_index
    after_update_commit :update_in_search_index
    after_destroy_commit :remove_from_search_index
  end

  def reindex
    update_in_search_index
  end

  private
    def ensure_current_account
      unless Current.account
        raise "Current.account must be set to save #{self.class.name}"
      end
    end

    def create_in_search_index
      create_search_record!(search_record_attributes)
    end

    def update_in_search_index
      search_record&.update!(search_record_attributes) || create_in_search_index
    end

    def remove_from_search_index
      search_record&.destroy
    end

    def search_record_attributes
      {
        account_id: account_id,
        searchable_type: self.class.name,
        searchable_id: id,
        card_id: search_card_id,
        board_id: search_board_id,
        title: search_title,
        content: search_content,
        created_at: created_at
      }
    end

  # Models must implement these methods:
  # - account_id: returns the account id
  # - search_title: returns title string or nil
  # - search_content: returns content string
  # - search_card_id: returns the card id (self.id for cards, card_id for comments)
  # - search_board_id: returns the board id
end
