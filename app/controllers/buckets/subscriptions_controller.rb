class Buckets::SubscriptionsController < ApplicationController
  include BucketScoped

  def update
    if params[:subscribed] == "1"
      @bucket.subscribe(Current.user)
    else
      @bucket.unsubscribe(Current.user)
    end
  end
end
