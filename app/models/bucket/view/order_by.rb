module Bucket::View::OrderBy
  extend ActiveSupport::Concern

  included do
    store_accessor :filters, :order_by
  end

  private
    ORDERS = {
      "most_discussed" => "most comments",
      "most_boosted" => "most boosts",
      "newest" => "newest",
      "oldest" => "oldest" }
end
