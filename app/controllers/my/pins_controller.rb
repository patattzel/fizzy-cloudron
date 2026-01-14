class My::PinsController < ApplicationController
  def index
    @pins = pins_for_request
    fresh_when etag: [ @pins, @pins.collect(&:card) ]
  end

  private
    def pins_for_request
      if request.format.json?
        Current.user.pins.includes(:card).ordered
      else
        Current.user.pins.includes(:card).ordered.limit(20)
      end
    end
end
