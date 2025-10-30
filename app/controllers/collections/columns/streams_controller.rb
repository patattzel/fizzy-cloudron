class Collections::Columns::StreamsController < ApplicationController
  include CollectionScoped

  def show
    set_page_and_extract_portion_from @collection.cards.awaiting_triage.by_last_activity.with_golden_first
    cards_fresh_when @page.records
  end
end
