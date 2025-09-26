class Columns::Cards::Drops::StreamsController < ApplicationController
  include CardScoped

  def create
    @card.send_back_to_triage
    set_page_and_extract_portion_from @collection.cards.awaiting_triage.reverse_chronologically

    render turbo_stream: turbo_stream.replace("the-stream", partial: "collections/show/stream", method: :morph, locals: { collection: @card.collection, page: @page })
  end
end
