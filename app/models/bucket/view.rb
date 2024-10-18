class Bucket::View < ApplicationRecord
  include Assignees, OrderBy, Status, Summarized, Tags

  belongs_to :creator, class_name: "User", default: -> { Current.user }
  belongs_to :bucket

  has_one :account, through: :creator

  validate :must_not_be_the_default_view

  class << self
    def default_filters
      { "order_by" => "most_active" }
    end
  end

  def filtered_bubbles
    bucket.filtered_bubbles filters
  end

  private
    def must_not_be_the_default_view
      if filters.values.all?(&:blank?) || filters == self.class.default_filters
        errors.add :base, "must be different than the default view"
      end
    end
end
