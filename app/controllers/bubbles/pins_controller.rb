class Bubbles::PinsController < ApplicationController
  include BubbleScoped, BucketScoped

  def show
  end

  def create
    pin = @bubble.pin_by Current.user

    broadcast_new pin
    redirect_to bucket_bubble_pin_path(@bucket, @bubble)
  end

  def destroy
    pin = @bubble.unpin_by Current.user

    broadcast_removed pin
    redirect_to bucket_bubble_pin_path(@bucket, @bubble)
  end

  private
    def broadcast_new(pin)
      pin.broadcast_prepend_later_to [ Current.user, :pins ], target: "pins", partial: "my/pins/pin"
    end

    def broadcast_removed(pin)
      pin.broadcast_remove_to [ Current.user, :pins ]
    end
end
