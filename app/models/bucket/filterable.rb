module Bucket::Filterable
  def bubble_filter_from(params = {})
    Bucket::BubbleFilter.new self, params
  end
end
