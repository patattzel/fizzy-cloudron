class My::PinsController < ApplicationController
  def index
    @pins = pins_for_request
    fresh_when etag: [ @pins, @pins.collect(&:card) ]
  end

  private
    def pins_for_request
      pins = Current.user.pins.includes(:card).ordered

      if request.format.json?
        pins.limit(100)
      else
        pins.limit(20)
      end
    end
end
