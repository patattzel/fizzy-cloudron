module Bubble::Poppable
  extend ActiveSupport::Concern

  AUTO_POP_AFTER = 30.days

  included do
    has_one :pop, dependent: :destroy

    scope :popped, -> { joins(:pop) }
    scope :active, -> { where.missing(:pop) }

    after_create -> { update_auto_pop_at(created_at) }
  end

  class_methods do
    def auto_pop_all_due
      active.where(auto_pop_at: ..Time.current).find_each do |bubble|
        bubble.pop!(user: bubble.bucket.account.users.system)
      end
    end
  end

  def update_auto_pop_at(timestamp)
    update!(auto_pop_at: timestamp + AUTO_POP_AFTER)
  end

  def popped?
    pop.present?
  end

  def popped_by
    pop&.user
  end

  def popped_at
    pop&.created_at
  end

  def pop!(user: Current.user)
    unless popped?
      create_pop!(user: user)
      track_event :popped, creator: user
    end
  end

  def unpop
    pop&.destroy
  end
end
