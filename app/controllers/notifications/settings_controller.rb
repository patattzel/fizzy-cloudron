class Notifications::SettingsController < ApplicationController
  def show
    @collections = Current.user.collections.alphabetically
  end
end
