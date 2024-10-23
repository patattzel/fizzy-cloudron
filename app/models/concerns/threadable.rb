module Threadable
  extend ActiveSupport::Concern

  included do
    has_one :thread_entry, as: :threadable

    after_create { create_thread_entry! bubble: bubble }
    after_update { bubble.touch }
    after_touch { bubble.touch }
  end
end
