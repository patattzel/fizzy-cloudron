class Command::AddCard < Command
  store_accessor :data, :card_title, :collection_id, :created_card_id

  validates :collection, presence: true

  def title
    "Create a new card with title '#{card_title}'"
  end

  def execute
    transaction do
      card = collection.cards.create!(title: card_title)
      update! created_card_id: card.id

      redirect_to collection_card_path(collection, card, focus_on_title: true)
    end
  end

  def undo
    created_card&.destroy
  end

  def undoable?
    true
  end

  private
    def closed_cards
      user.accessible_cards.where(id: closed_card_ids)
    end

    def collection
      user.collections.find_by_id(collection_id)
    end

    def created_card
      user.accessible_cards.find_by_id(created_card_id)
    end
end
