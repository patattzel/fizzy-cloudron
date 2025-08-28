class Notifications::SettingsController < ApplicationController
  include FilterScoped

  def show
    @collections = Current.user.collections.alphabetically
  end
end
