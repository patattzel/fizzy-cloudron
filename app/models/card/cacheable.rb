module Card::Cacheable
  extend ActiveSupport::Concern

  def cache_key
    [ super, collection.name ].compact.join("/")
  end

  def cache_invalidation_parts
    @cache_invalidation_parts ||= InvalidationParts.new(self)
  end

  class InvalidationParts
    attr_reader :card

    def initialize(card)
      @card = card
    end

    def for_perma(*other)
      [ card, Workflow.all, User.all, Tag.all, *other ]
    end

    def for_preview(*other)
      [ card, card.workflow, Workflow.all, card.collection.entropy_configuration, card.collection.publication, *other ]
    end
  end
end
