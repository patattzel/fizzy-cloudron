class Cards::PinsController < ApplicationController
  include CardScoped

  def show
  end

  def create
    pin = @card.pin_by Current.user
    broadcast_my_new pin
  end

  def destroy
    pin = @card.unpin_by Current.user
    broadcast_my_removed pin
  end

  private
    def broadcast_my_new(pin)
      pin.broadcast_prepend_later_to [ Current.user, :pins ], target: "pins", partial: "my/pins/pin"
    end

    def broadcast_my_removed(pin)
      pin.broadcast_remove_to [ Current.user, :pins ]
    end
end
