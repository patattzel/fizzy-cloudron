module Threadable
  extend ActiveSupport::Concern

  included do
    has_one :thread_entry, as: :threadable
    after_create { create_thread_entry! bubble: bubble }
  end
end
