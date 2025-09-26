class Columns::Cards::Drops::NotNowsController < ApplicationController
  include CardScoped

  def create
    @card.postpone

    render turbo_stream: turbo_stream.replace("now-now-cards", partial: "collections/show/not_now", locals: { collection: @card.collection })
  end
end
