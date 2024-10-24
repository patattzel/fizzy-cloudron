module Bubble::Threaded
  extend ActiveSupport::Concern

  included do
    has_one :thread, dependent: :destroy

    after_create -> { create_thread! }
  end
end
