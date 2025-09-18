class Cards::Columns::Column
  attr_reader :page, :user_filtering

  delegate :filter, to: :user_filtering

  def initialize(page:, user_filtering:)
    @page = page
    @user_filtering = user_filtering
  end

  def cards
    page.records
  end

  def cache_key
    ActiveSupport::Cache.expand_cache_key([cards])
  end
end
