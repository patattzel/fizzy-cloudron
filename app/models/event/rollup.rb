class Event::Rollup < ApplicationRecord
  include Threadable

  attr_accessor :thread

  has_many :events, -> { chronologically }, dependent: :delete_all

  def to_partial_path
    "events/rollups/rollup"
  end
end
