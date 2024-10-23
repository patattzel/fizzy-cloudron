module Bubble::Threaded
  extend ActiveSupport::Concern

  included do
    has_many :thread_entries, -> { chronologically }, dependent: :destroy

    delegate :latest_rollup, to: :thread
  end

  def thread
    @thread ||= Bubble::Thread.new self
  end
end
