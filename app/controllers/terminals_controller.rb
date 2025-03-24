class TerminalsController < ApplicationController
  def show
    @events = Event.where(bubble: user_bubbles, creator: Current.user).chronologically.reverse_order.limit(20)
  end

  def edit
    @filter = Current.user.filters.from_params params.permit(*Filter::PERMITTED_PARAMS)
  end

  private
    def user_bubbles
      Current.user.accessible_bubbles
    end
end
