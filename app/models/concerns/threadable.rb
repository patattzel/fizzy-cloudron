module Threadable
  extend ActiveSupport::Concern

  TYPES = %w[ Comment Event::Rollup ]

  included do
    has_one :thread_entry, as: :threadable, class_name: "Bubble::Thread::Entry"

    after_create -> { create_thread_entry! thread: thread }
  end
end
