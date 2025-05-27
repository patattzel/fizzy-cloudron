class ApplicationController < ActionController::Base
  include Authentication, CurrentTimezone, SetPlatform

  stale_when_importmap_changes
  allow_browser versions: :modern
end
