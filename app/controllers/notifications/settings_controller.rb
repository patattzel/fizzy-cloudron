module Notifications
  class SettingsController < ApplicationController
    def show
      @buckets = Current.user.buckets.alphabetically
    end
  end
end
