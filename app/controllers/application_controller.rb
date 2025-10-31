class ApplicationController < ActionController::Base
  include LoadBalancerRouting, WriterAffinity
  include Authentication
  include Authorization
  include CurrentRequest, CurrentTimezone, SetPlatform
  include TurboFlash, ViewTransitions

  stale_when_importmap_changes
  allow_browser versions: :modern
end
