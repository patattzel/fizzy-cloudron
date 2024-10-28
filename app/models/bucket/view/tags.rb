module Bucket::View::Tags
  extend ActiveSupport::Concern

  included do
    store_accessor :filters, :tag_ids
  end

  private
    def tags
      @tags ||= account.tags.where id: tag_ids
    end
end
