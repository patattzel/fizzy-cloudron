class Bubbles::Pins::TraysController < ApplicationController
  def show
    @pins = Current.user.pins.includes(:bubble).ordered.limit(20)
  end
end
