module Filter::Buckets
  extend ActiveSupport::Concern

  included do
    store_accessor :params, :bucket_ids
  end

  def buckets
    @buckets ||= account.buckets.where id: bucket_ids.to_s.split(",")
  end
end
