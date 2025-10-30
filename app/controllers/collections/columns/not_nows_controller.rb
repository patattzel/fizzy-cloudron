class Collections::Columns::NotNowsController < ApplicationController
  include CollectionScoped

  def show
    set_page_and_extract_portion_from @collection.cards.postponed.reverse_chronologically.with_golden_first
    cards_fresh_when @page.records
  end
end
